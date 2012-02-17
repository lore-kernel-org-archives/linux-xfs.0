Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1HL6Uu4110298 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 15:06:30 -0600
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id WiXwrufcGPUvBH7S (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Feb 2012 13:06:29 -0800 (PST)
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Fri, 17 Feb 2012 16:06:27 -0500
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 5692638C803A
	for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 16:06:18 -0500 (EST)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q1HL6Hm2234548 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 16:06:17 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	q1HL6HIX001787 for <xfs@oss.sgi.com>; Fri, 17 Feb 2012 19:06:17 -0200
Subject: Re: [RFC v3 PATCH 1/4] xfs: Remove incore use of XFS_OQUOTA_ENFD
	and XFS_OQUOTA_CHKD
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20120217183902.GE7762@sgi.com>
References: <20120123173158.31640.30333.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120123173204.31640.53918.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120211004112.GP7762@sgi.com>
	<1329149157.2213.55.camel@chandra-lucid.austin.ibm.com>
	<20120217183902.GE7762@sgi.com>
Date: Fri, 17 Feb 2012 15:05:55 -0600
Message-ID: <1329512755.2213.61.camel@chandra-lucid.austin.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

Fine by me. Will make these changes in my next version.

But, the situation may not be temporary as we have to support
OQUOTA for backward compatibility reasons.

Chandra 

On Fri, 2012-02-17 at 12:39 -0600, Ben Myers wrote:
> Hey Chandra,
> 
> On Mon, Feb 13, 2012 at 10:05:57AM -0600, Chandra Seetharaman wrote:
> > On Fri, 2012-02-10 at 18:41 -0600, Ben Myers wrote:
> > 
> > <snip>
> > 
> > > > @@ -657,6 +686,7 @@ xfs_sb_to_disk(
> > > >  
> > > >  		fields &= ~(1LL << f);
> > > >  	}
> > > > +	from->sb_qflags = saved_qflags;
> > > 
> > > I am disgusted that you should have to save the sb_qflags like this.
> > > After reading this 'fields' loop in xfs_sb_to_disk along with all the
> > > related crap I am actually feeling a little nauseous.
> > 
> > Let me know if you have any other solutions. I am open for it.
> 
> How would you feel about something like this?
> 
> @@ -622,6 +636,7 @@ xfs_sb_to_disk(
>         xfs_sb_field_t  f;
>         int             first;
>         int             size;GMCR
> +       __uint16_t      tmp16;
> 
>         ASSERT(fields);
>         if (!fields)
> @@ -636,6 +651,27 @@ xfs_sb_to_disk(
> 
>                 if (size == 1 || xfs_sb_info[f].type == 1) {
>                         memcpy(to_ptr + first, from_ptr + first, size);
> +               } else if (f == XFS_SBS_QFLAGS) {
> +                       /*
> +                        * The in-core version of sb_qflags do not have
> +                        * XFS_OQUOTA_* flags, whereas the on-disk version
> +                        * does.  Save the in-core sb_qflags temporarily,
> +                        * removing the new XFS_{PG}QUOTA_* flags and re-apply
> +                        * the old on-disk flags.  This is a temporary
> +                        * situation until the on-disk flags are updated.
> +                        */
> +                       tmp16 = from->sb_qflags &
> +                                       ~(XFS_PQUOTA_ENFD | XFS_PQUOTA_CHKD |
> +                                         XFS_GQUOTA_ENFD | XFS_GQUOTA_CHKD);
> +
> +                       if (from->sb_qflags &
> +                                       (XFS_PQUOTA_ENFD | XFS_GQUOTA_ENFD))
> +                               tmp16 |= XFS_OQUOTA_ENFD;
> +                       if (from->sb_qflags &
> +                                       (XFS_PQUOTA_CHKD | XFS_GQUOTA_CHKD))
> +                               tmp16 |= XFS_OQUOTA_CHKD;
> +
> +                       *(__be16 *)(to_ptr + first) = cpu_to_be16(tmp16);
>                 } else {
>                         switch (size) {
>                         case 2:
> 
> This way we needn't worry about any change (or locking) of the incore
> superblock sb_qflags.
> 
> > > I don't know why in XFS we seem to feel the need to do everything in the
> > > most complicated way possible.
> 
> I suppose they were trying to cut down on conditionals on fields... maybe
> something that could be done better at compile time... someday.
> 
> Regards,
> 	Ben
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
