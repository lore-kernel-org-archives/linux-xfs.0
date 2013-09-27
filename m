Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 983287F3F
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 00:24:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 72C0A30405F
	for <xfs@oss.sgi.com>; Thu, 26 Sep 2013 22:24:30 -0700 (PDT)
Received: from e28smtp04.in.ibm.com (e28smtp04.in.ibm.com [122.248.162.4]) by
	cuda.sgi.com with ESMTP id HMtH67eQABcFp0Qe (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 26 Sep 2013 22:24:29 -0700 (PDT)
Received: from /spool/local
	by e28smtp04.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zhong@linux.vnet.ibm.com>;
	Fri, 27 Sep 2013 10:54:23 +0530
Received: from d28relay01.in.ibm.com (d28relay01.in.ibm.com [9.184.220.58])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id CAF00394004E
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 10:54:06 +0530 (IST)
Received: from d28av04.in.ibm.com (d28av04.in.ibm.com [9.184.220.66])
	by d28relay01.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r8R5QfU236110470
	for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 10:56:41 +0530
Received: from d28av04.in.ibm.com (localhost [127.0.0.1])
	by d28av04.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	r8R5OLnD019693 for <xfs@oss.sgi.com>; Fri, 27 Sep 2013 10:54:22 +0530
Message-ID: <1380259459.2836.2.camel@ThinkPad-T5421>
Subject: Re: [PATCH v3 1/2] xfsprogs: fix potential memory leak in
	verify_set_primary_sb()
From: Li Zhong <zhong@linux.vnet.ibm.com>
Date: Fri, 27 Sep 2013 13:24:19 +0800
In-Reply-To: <47016750-3840-4770-873C-5D77050EEBCE@sandeen.net>
References: <1379829679.4089.2.camel@ThinkPad-T5421>
	<5241E125.7010902@sgi.com> <1380094327.2526.5.camel@ThinkPad-T5421>
	<5242F31B.4060902@sandeen.net>
	<1380177932.2983.11.camel@ThinkPad-T5421>
	<5244453D.6010605@sandeen.net> <1380251129.2836.1.camel@ThinkPad-T5421>
	<47016750-3840-4770-873C-5D77050EEBCE@sandeen.net>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, Mark Tinguely <tinguely@sgi.com>, xfsprogs <xfs@oss.sgi.com>

On Thu, 2013-09-26 at 22:24 -0500, Eric Sandeen wrote:
> 
> > On Sep 26, 2013, at 10:05 PM, Li Zhong <zhong@linux.vnet.ibm.com> wrote:
> > 
> >> On Thu, 2013-09-26 at 09:31 -0500, Eric Sandeen wrote:
> >>> On 9/26/13 1:45 AM, Li Zhong wrote:
> >>> If verify_set_primary_sb() completes the secondary sb scanning loop with
> >>> too few valid secondaries found (num_ok < num_sbs / 2), it will immediately
> >>> return without freeing any of the previously allocated memory (variables
> >>> sb, checked, and any items on the geo list).  This was reported by
> >>> the Coverity scanner as CID 997012, 997013 and 997014.
> >>> 
> >>> Fix this by using the out_free_list: goto target for this error case.
> >>> 
> >>> Earlier, if get_sb() fails in the secondary scan loop, it goes to
> >>> the out: target which does not free any items on the geo list.   Fix
> >>> this by using the out_free_list: target as well, and remove the now-unused
> >>> out: target.
> >>> 
> >>> Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
> >>> ---
> >>> v2: as Mark pointed out, out in the for loop before also needs list to
> >>> be freed. Also remove out lable as it is not referenced any more.
> >>> v3: use a meaningful changlog from Eric, and hide the patch changlogs below "---".
> >> 
> >> Thanks for that; you can add my:
> >> 
> >> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> >> 
> >> alongside Mark's.
> > 
> > Ah, I missed that. Is it ok to just add it here in this mail? 
> > 
> > Reviewed-by: Mark Tinguely <tinguely@sgi.com>
> > 
> Sorry, I meant that for sgi but wasn't clear.  Sometimes I talk too much.  :)

Oh, I see :)

Thanks, Zhong

> 
> Eric
> 
> >> 
> >>> repair/sb.c | 9 +++++----
> >>> 1 file changed, 5 insertions(+), 4 deletions(-)
> >>> 
> >>> diff --git a/repair/sb.c b/repair/sb.c
> >>> index aa550e3..d34d7a2 100644
> >>> --- a/repair/sb.c
> >>> +++ b/repair/sb.c
> >>> @@ -733,7 +733,7 @@ verify_set_primary_sb(xfs_sb_t        *rsb,
> >>> 
> >>>            if (get_sb(sb, off, size, agno) == XR_EOF)  {
> >>>                retval = 1;
> >>> -                goto out;
> >>> +                goto out_free_list;
> >>>            }
> >>> 
> >>>            if (verify_sb(sb, 0) == XR_OK)  {
> >>> @@ -756,8 +756,10 @@ verify_set_primary_sb(xfs_sb_t        *rsb,
> >>>    /*
> >>>     * see if we have enough superblocks to bother with
> >>>     */
> >>> -    if (num_ok < num_sbs / 2)
> >>> -        return(XR_INSUFF_SEC_SB);
> >>> +    if (num_ok < num_sbs / 2) {
> >>> +        retval = XR_INSUFF_SEC_SB;
> >>> +        goto out_free_list;
> >>> +    }
> >>> 
> >>>    current = get_best_geo(list);
> >>> 
> >>> @@ -841,7 +843,6 @@ verify_set_primary_sb(xfs_sb_t        *rsb,
> >>> 
> >>> out_free_list:
> >>>    free_geo(list);
> >>> -out:
> >>>    free(sb);
> >>>    free(checked);
> >>>    return(retval);
> > 
> > 
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
