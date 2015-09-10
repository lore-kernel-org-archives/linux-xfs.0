Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CD3F47F47
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 07:30:39 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AE49E8F804C
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 05:30:36 -0700 (PDT)
Received: from posti6.jyu.fi (posti6.jyu.fi [130.234.4.43]) by cuda.sgi.com
	with ESMTP id oowgiXLDnzkHF1YD (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 10 Sep 2015 05:30:34 -0700 (PDT)
Date: Thu, 10 Sep 2015 15:30:30 +0300
From: Tapani Tarvainen <tapani.j.tarvainen@jyu.fi>
Subject: Re: "This is a bug."
Message-ID: <20150910123030.GG26847@tehanu.it.jyu.fi>
References: <20150910091834.GC24937@tehanu.it.jyu.fi>
	<20150910134828.0bdfcc4c@harpe.intellique.com>
	<20150910115548.GD26847@tehanu.it.jyu.fi>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150910115548.GD26847@tehanu.it.jyu.fi>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

On 10 Sep 14:55, Tapani Tarvainen (tapani.j.tarvainen@jyu.fi) wrote:
> On 10 Sep 13:48, Emmanuel Florac (eflorac@intellique.com) wrote:
> 
> > > xfsprogs version 3.1.7+b1.
> > 
> > Don't use that, it's much too old. Use at least a 3.2.x version, or if
> > possible the very latest version of xfs_repair.

With (self-compiled) 4.2.0 version xfs_repair without -L no longer
refuses to run but after a while failed with

[...]
correcting nextents for inode 2152363147
xfs_repair: dinode.c:1961: process_inode_data_fork: Assertion `err == 0' failed.
Aborted

With -L ... same result.

-- 
Tapani Tarvainen

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
