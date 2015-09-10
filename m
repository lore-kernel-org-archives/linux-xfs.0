Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 376687F47
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 06:55:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2742A304039
	for <xfs@oss.sgi.com>; Thu, 10 Sep 2015 04:55:57 -0700 (PDT)
Received: from posti6.jyu.fi (posti6.jyu.fi [130.234.4.43]) by cuda.sgi.com
	with ESMTP id XDot1PrDAHek0SUa (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 10 Sep 2015 04:55:53 -0700 (PDT)
Date: Thu, 10 Sep 2015 14:55:48 +0300
From: Tapani Tarvainen <tapani.j.tarvainen@jyu.fi>
Subject: Re: "This is a bug."
Message-ID: <20150910115548.GD26847@tehanu.it.jyu.fi>
References: <20150910091834.GC24937@tehanu.it.jyu.fi>
	<20150910134828.0bdfcc4c@harpe.intellique.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150910134828.0bdfcc4c@harpe.intellique.com>
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

On 10 Sep 13:48, Emmanuel Florac (eflorac@intellique.com) wrote:

> > xfsprogs version 3.1.7+b1.
> 
> Don't use that, it's much too old. Use at least a 3.2.x version, or if
> possible the very latest version of xfs_repair. You can copy over
> xfs_repair from another machine as it's a static binary.

Seems it isn't static in Debian (copied over from a Jessie box):

# /home/tt/xfs_repair -v /dev/sdata1/data1
/home/tt/xfs_repair: /lib/x86_64-linux-gnu/libc.so.6: version `GLIBC_2.14' not found (required by /home/tt/xfs_repair)

But if a new version is really likely to help I can build
it from source. Thank you for the suggestion.

-- 
Tapani Tarvainen

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
