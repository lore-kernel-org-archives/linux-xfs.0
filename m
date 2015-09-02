Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7DE137F60
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2015 13:49:50 -0500 (CDT)
Subject: Re: [RESEND PATCH] xfsrestore: fix fs uuid order check for
	incremental restores
References: <20150826213133.GB3902@dastard> <55D5FB95.1280108@sgi.com>
	<20150902132112.GB23587@bfoster.bfoster>
From: Rich Johnston <rjohnston@sgi.com>
Message-ID: <55E744CB.1080409@sgi.com>
Date: Wed, 2 Sep 2015 13:49:47 -0500
MIME-Version: 1.0
In-Reply-To: <20150902132112.GB23587@bfoster.bfoster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On 09/02/2015 08:21 AM, Brian Foster wrote:
> On Tue, Sep 01, 2015 at 03:38:29PM -0500, Rich Johnston wrote:
>> Restoring an incremental level 1 dump will fail with the following error
>> if the fs uuid of the most recent level 0 dump in the inventory does not
>> match level 1 dump we are restoring.
>>
>>    xfsrestore: ERROR: selected dump not based on previously applied dump
>>
>> This can happen when you have multiple filesystems and you are restoring
>> a level 1 or greater dump of filesystem FS1 but the most recent level 0
>> dump in the inventory was filesystem FS2
>>
>> The fix is to ensure the fs uuid of the inventory entry and the dump to
>> be restored match.
>>
>> Signed-off-by: Rich Johnston <rjohnston@sgi.com>
>> ---
>
> I'm not really familiar with xfsdump, but a few comments below...
>
>>   dump/content.c        |    8 ++-
>>   inventory/inv_api.c   |  108 ++++++++++++++++++++++++++++++--------------------
>>   inventory/inv_mgr.c   |   32 ++++++++++----
>>   inventory/inv_priv.h  |    7 +--
>>   inventory/inventory.h |    5 ++
>>   restore/content.c     |   17 +++++--
>>   6 files changed, 113 insertions(+), 64 deletions(-)
>>
> ...
>> Index: b/inventory/inv_mgr.c
>> ===================================================================
>> --- a/inventory/inv_mgr.c
>> +++ b/inventory/inv_mgr.c
>> @@ -134,6 +134,7 @@ get_sesstoken( inv_idbtoken_t tok )
>>   /*---------------------------------------------------------------------------*/
>>   bool_t
>>   invmgr_query_all_sessions (
>> +	uuid_t *fsidp,
>>   	void *inarg,
>>   	void **outarg,
>>   	search_callback_t func)
>> @@ -169,7 +170,7 @@ invmgr_query_all_sessions (
>>   			mlog( MLOG_NORMAL | MLOG_INV, _(
>>   			     "INV: Cant get inv-name for uuid\n")
>>   			     );
>> -			return BOOL_FALSE;
>> +			continue;
>>   		}
>>   		strcat( fname, INV_INVINDEX_PREFIX );
>>   		invfd = open( fname, INV_OFLAG(forwhat) );
>> @@ -178,9 +179,9 @@ invmgr_query_all_sessions (
>>   			     "INV: Open failed on %s\n"),
>>   			     fname
>>   			     );
>> -			return BOOL_FALSE;
>> +			continue;
>>   		}
>
> Now that the above two cases don't return false, we can end up returning
> true if these error cases persist throughout the loop.
Yes I missed that case.
> Perhaps we should
> define 'bool ret = false,' return that variable everywhere and only set
> it true when appropriate.
Good suggestion.
>
>> -		result = search_invt( invfd, inarg, &objectfound, func );
>> +		result = search_invt(fsidp, invfd, inarg, &objectfound, func);
>>   		close(invfd);		
>>
>>   		/* if error return BOOL_FALSE */
> ...
>> @@ -272,19 +274,31 @@ search_invt(
>>   		}
>>   		free ( scnt );
>>
>> -		while ( nsess ) {
>> +		for (j = nsess - 1; j >= 0; j--) {
>> +			invt_session_t ses;
>> +
>>   			/* fd is kept locked until we return from the
>>   			   callback routine */
>>
>>   			/* Check to see if this session has been pruned
>>   			 * by xfsinvutil before checking it.
>>   			 */
>> -			if ( harr[nsess - 1].sh_pruned ) {
>> -				--nsess;
>> +			if (harr[j].sh_pruned) {
>>   				continue;
>>   			}
>> -			found = (* do_chkcriteria ) ( fd, &harr[ --nsess ],
>> -						      arg, buf );
>> +
>> +			/* if we need to check the fs uuid's and they don't
>> +			 * match or we fail to get the session record,
>> +			 * then keep looking
>> +			 */
>> +			if (fsidp &&
>> +			    (GET_REC_NOLOCK(fd, &ses, sizeof(invt_session_t),
>> +					    harr[j].sh_sess_off) ==
>> +			    sizeof(invt_session_t)) &&
>> +			    uuid_compare(ses.s_fsid, *fsidp))
>> +				continue ;
>> +
>
> This seems like kind of a loaded check. GET_REC_NOLOCK() looks like it
> returns -1 if the read doesn't return the exact size of the buffer, so
> we probably don't need to check that here. It also seems like we should
> return an error if an error occurs rather than just continue on. How
> about something like this?
Sounds reasonable, would be more readable.
>
> 			...
> 			if (fsidp) {
> 				ret = GET_REC_NOLOCK(fd, &ses,
> 						     sizeof(invt_session_t),
> 						     harr[j].sh_sess_off);
> 				if (ret < 0) {
> 					/* XXX: clean up here */
> 					return ret;
> 				}
> 				ret = uuid_compare(ses.s_fsid, *fsidp);
> 				if (ret)
> 					continue;
> 			}
>
>> +			found = (* do_chkcriteria ) (fd, &harr[j], arg, buf);
>>   			if (! found ) continue;
>>   			
>>   			/* we found what we need; just return */
> ...
>> Index: b/restore/content.c
>> ===================================================================
>> --- a/restore/content.c
>> +++ b/restore/content.c
>> @@ -2179,8 +2179,9 @@ content_stream_restore( ix_t thrdix )
>>   		if ( ! drivep->d_isnamedpipepr
>>   		     &&
>>   		     ! drivep->d_isunnamedpipepr ) {
>> -			ok = inv_get_session_byuuid( &grhdrp->gh_dumpid,
>> -						     &sessp );
>> +			ok = inv_get_session_byuuid((uuid_t *)0,
>> +						    &grhdrp->gh_dumpid,
>> +						    &sessp);
>>   			if ( ok && sessp ) {
>>   				mlog( MLOG_VERBOSE, _(
>>   				      "using online session inventory\n") );
>> @@ -3736,9 +3737,11 @@ Inv_validate_cmdline( void )
>>   	ok = BOOL_FALSE;
>>   	sessp = 0;
>>   	if ( tranp->t_reqdumpidvalpr ) {
>> -		ok = inv_get_session_byuuid( &tranp->t_reqdumpid, &sessp );
>> +		ok = inv_get_session_byuuid((uuid_t *)0, &tranp->t_reqdumpid,
>> +					    &sessp );
>>   	} else if ( tranp->t_reqdumplabvalpr ) {
>> -		ok = inv_get_session_bylabel( tranp->t_reqdumplab, &sessp );
>> +		ok = inv_get_session_bylabel((uuid_t *)0, tranp->t_reqdumplab,
>> +					     &sessp );
>
> Can we use NULL instead of 0 in these cases? Not sure the cast is really
> necessary either..?.
I will check that out, if NULL works I will make that change.

Thanks for your time
--Rich
>
> Brian
>
>>   	}
>>   	rok = BOOL_FALSE;
>>   	if ( ok && sessp ) {
>> @@ -6812,11 +6815,13 @@ askinvforbaseof( uuid_t baseid, inv_sess
>>   	/* get the base session
>>   	 */
>>   	if ( resumedpr ) {
>> -		ok = inv_lastsession_level_equalto( invtok,
>> +		ok = inv_lastsession_level_equalto( &sessp->s_fsid,
>> +						    invtok,
>>   						    ( u_char_t )level,
>>   						    &basesessp );
>>   	} else {
>> -		ok = inv_lastsession_level_lessthan( invtok,
>> +		ok = inv_lastsession_level_lessthan( &sessp->s_fsid,
>> +						     invtok,
>>   						     ( u_char_t )level,
>>   						     &basesessp );
>>   	}
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
