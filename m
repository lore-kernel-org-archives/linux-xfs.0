Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Feb 2008 18:34:42 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1S2YcfP015935
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2008 18:34:39 -0800
Received: from postoffice.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B069BEE166C
	for <xfs@oss.sgi.com>; Wed, 27 Feb 2008 18:35:04 -0800 (PST)
Received: from postoffice.aconex.com (prod.aconex.com [203.89.192.138]) by cuda.sgi.com with ESMTP id TYTjEJ4O8Juk50n1 for <xfs@oss.sgi.com>; Wed, 27 Feb 2008 18:35:04 -0800 (PST)
Subject: Re: [REVIEW] Don't make lazy counters default for mkfs
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <op.t67mtawg3jf8g2@pc-bnaujok.melbourne.sgi.com>
References: <op.t67mtawg3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 13:35:01 +1100
Message-Id: <1204166101.13569.102.camel@edge.scott.net.au>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Thu, 2008-02-28 at 12:09 +1100, Barry Naujok wrote:
> 
> 
> Lazy superblock counters was released into mainline in 2.6.23-rc1.
> Some  
> distros are still running an older kernel (2.6.22 for example) and
> with  

(many distros?  RHEL5 and SLES10 wont have such recent kernels yet,
right?)

> the latest xfsprogs, cannot mount a freshly made filesystem with
> default  
> options.
> 
> This patch make lazy counters default back to off now.

Looks good, thanks.

> Users who have a more recent kernel can easily enable them with mkfs
> or  
> xfs_admin -c1 (in a patch posted out a few days ago which will be in
> the  
> same xfsprogs release as this patch).
> 
> Lazy counters will default to on again in xfsprogs 2.10.0 (when CI
> support  
> is released). This should give enough time for distro kernels to catch
> up.

Hmm, that still seems pretty soon to me.  I'd have thought you'd at
least want to wait until most of the distributions (esp. SUSE for you
guys) have released versions that have kernels sufficiently recent
that the default mkfs will work.  Otherwise this will be a recurring
problem.

cheers.

-- 
Nathan
