Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1DG83xt021085 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 10:08:04 -0600
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150]) by
	cuda.sgi.com with ESMTP id Qgt7wRY4RxdHqLFZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Feb 2012 08:08:02 -0800 (PST)
Received: from /spool/local
	by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Mon, 13 Feb 2012 09:08:00 -0700
Received: from d01relay05.pok.ibm.com (d01relay05.pok.ibm.com [9.56.227.237])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 4735CC90070
	for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 11:06:05 -0500 (EST)
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay05.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	q1DG62RR211628 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 11:06:02 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	q1DG61Lx030026 for <xfs@oss.sgi.com>; Mon, 13 Feb 2012 14:06:01 -0200
Subject: Re: [RFC v3 PATCH 1/4] xfs: Remove incore use of XFS_OQUOTA_ENFD
	and XFS_OQUOTA_CHKD
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20120211004112.GP7762@sgi.com>
References: <20120123173158.31640.30333.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120123173204.31640.53918.sendpatchset@chandra-lucid.austin.ibm.com>
	<20120211004112.GP7762@sgi.com>
Date: Mon, 13 Feb 2012 10:05:57 -0600
Message-ID: <1329149157.2213.55.camel@chandra-lucid.austin.ibm.com>
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

On Fri, 2012-02-10 at 18:41 -0600, Ben Myers wrote:

<snip>

> > @@ -657,6 +686,7 @@ xfs_sb_to_disk(
> >  
> >  		fields &= ~(1LL << f);
> >  	}
> > +	from->sb_qflags = saved_qflags;
> 
> I am disgusted that you should have to save the sb_qflags like this.
> After reading this 'fields' loop in xfs_sb_to_disk along with all the
> related crap I am actually feeling a little nauseous.

Let me know if you have any other solutions. I am open for it.
> 
> I don't know why in XFS we seem to feel the need to do everything in the
> most complicated way possible.
> 
> The rest of the patch looks good.
> 
> Reviewed-by: Ben Myers <bpm@sgi.com>

Thanks.

<snip>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
