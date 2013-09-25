Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3E83C7F3F
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 02:34:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1EA748F804C
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 00:34:44 -0700 (PDT)
Received: from e28smtp07.in.ibm.com (e28smtp07.in.ibm.com [122.248.162.7]) by
	cuda.sgi.com with ESMTP id 0v8AYwtjFHJhFFUQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 25 Sep 2013 00:34:42 -0700 (PDT)
Received: from /spool/local
	by e28smtp07.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <zhong@linux.vnet.ibm.com>;
	Wed, 25 Sep 2013 13:04:38 +0530
Received: from d28relay05.in.ibm.com (d28relay05.in.ibm.com [9.184.220.62])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id 9AD901258056
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 13:04:48 +0530 (IST)
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay05.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r8P7YY5j40173700
	for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 13:04:34 +0530
Received: from d28av02.in.ibm.com (localhost [127.0.0.1])
	by d28av02.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	r8P7YZcO023344 for <xfs@oss.sgi.com>; Wed, 25 Sep 2013 13:04:35 +0530
Message-ID: <1380094473.2526.8.camel@ThinkPad-T5421>
Subject: Re: [PATCH] xfsprogs: fix potential memory leak in
	verify_set_primary_sb()
From: Li Zhong <zhong@linux.vnet.ibm.com>
Date: Wed, 25 Sep 2013 15:34:33 +0800
In-Reply-To: <5241E125.7010902@sgi.com>
References: <1379829679.4089.2.camel@ThinkPad-T5421> <5241E125.7010902@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, xfsprogs <xfs@oss.sgi.com>

On Tue, 2013-09-24 at 13:59 -0500, Mark Tinguely wrote:
> On 09/22/13 01:01, Li Zhong wrote:
> > This patch tries to fix CID 997012, 997013 and 997014 reported by Coverity scan,
> > as suggested by sekharan.
> >
> > Signed-off-by: Li Zhong<zhong@linux.vnet.ibm.com>
> > ---
> 
> 
> > @@ -756,8 +756,10 @@ verify_set_primary_sb(xfs_sb_t		*rsb,
> >   	/*
> >   	 * see if we have enough superblocks to bother with
> >   	 */
> > -	if (num_ok < num_sbs / 2)
> > -		return(XR_INSUFF_SEC_SB);
> > +	if (num_ok < num_sbs / 2) {
> > +		retval = XR_INSUFF_SEC_SB;
> > +		goto out_free_list;
> > +	}
> 
> >
> 
> Looks good. list, sb and check could have been allocated at this point.
> 
> Isn't the list been added to before the conditional in the for loop?:

See, I just sent a new version including below change.

Seems it is a Coverity scan bug not discovering this :)

Thanks, Zhong

> 
>          list = add_geo(list, &geo, sb_index);
> 
>          /*
>           * grab N secondaries.  check them off as we get them
>           * so we only process each one once
>           */
>          for (round = 0; round < skip; round++)  {
> 
> ...
>                          if (get_sb(sb, off, size, agno) == XR_EOF)  {
>                                  retval = 1;
>                                  goto out;
> 				^^^^^^^^^ out_free_list?
>                          }
> 
> --Mark.
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
