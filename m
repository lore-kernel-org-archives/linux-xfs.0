Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8C4C07F47
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 07:36:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 24D07AC008
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 05:36:07 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HF2igtCpvvF5QFkO (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 10 Sep 2015 05:36:06 -0700 (PDT)
Date: Thu, 10 Sep 2015 08:36:04 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: "This is a bug."
Message-ID: <20150910123603.GA27863@bfoster.bfoster>
References: <20150910091834.GC24937@tehanu.it.jyu.fi>
	<20150910134828.0bdfcc4c@harpe.intellique.com>
	<20150910115548.GD26847@tehanu.it.jyu.fi>
	<20150910123030.GG26847@tehanu.it.jyu.fi>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150910123030.GG26847@tehanu.it.jyu.fi>
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
To: Tapani Tarvainen <tapani.j.tarvainen@jyu.fi>
Cc: xfs@oss.sgi.com

On Thu, Sep 10, 2015 at 03:30:30PM +0300, Tapani Tarvainen wrote:
> On 10 Sep 14:55, Tapani Tarvainen (tapani.j.tarvainen@jyu.fi) wrote:
> > On 10 Sep 13:48, Emmanuel Florac (eflorac@intellique.com) wrote:
> > 
> > > > xfsprogs version 3.1.7+b1.
> > > 
> > > Don't use that, it's much too old. Use at least a 3.2.x version, or if
> > > possible the very latest version of xfs_repair.
> 
> With (self-compiled) 4.2.0 version xfs_repair without -L no longer
> refuses to run but after a while failed with
> 
> [...]
> correcting nextents for inode 2152363147
> xfs_repair: dinode.c:1961: process_inode_data_fork: Assertion `err == 0' failed.
> Aborted
> 
> With -L ... same result.
> 

Care to post the metadump?

Brian

> -- 
> Tapani Tarvainen
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
