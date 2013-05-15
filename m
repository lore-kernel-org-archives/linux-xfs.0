Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4311C29E06
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 16:58:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1FFBB8F8037
	for <xfs@oss.sgi.com>; Wed, 15 May 2013 14:58:07 -0700 (PDT)
Received: from exprod7og125.obsmtp.com (exprod7og125.obsmtp.com [64.18.2.28])
	by cuda.sgi.com with SMTP id cpnFrhEGtPvpLhoM (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 15 May 2013 14:58:06 -0700 (PDT)
Message-ID: <519404E6.5010502@genband.com>
Date: Wed, 15 May 2013 15:57:58 -0600
From: Chris Friesen <chris.friesen@genband.com>
MIME-Version: 1.0
Subject: Re: 2.6.27-based kernel failing xfstests xfs/182 -- resolved, I think
References: <519176E7.8070204@genband.com>
In-Reply-To: <519176E7.8070204@genband.com>
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
To: Ben Myers <bpm@sgi.com>, Alex Elder <elder@kernel.org>, xfs@oss.sgi.com

On 05/13/2013 05:27 PM, Chris Friesen wrote:
>
> Hi,
>
> I'm working on an embedded system running a 2.6.27-based kernel.
>
> I'm digging into some intermittent xfs corruption issues. Yes, I realize
> the right answer is probably to upgrade, but for the usual embedded
> reasons that's tricky.
>
> I'm seeing test xfs/182 fail with 40 or so files showing messages like:
>
> file /opt/xfstest2/960 has incorrect size - sync failed
>
> In our case the xfs filesystems used for testing are on top of lvm,
> which is in turn on top of two SAS drives in RAID1.
>
> Any suggestions on where I should start looking? I'm looking at the
> "do_sync() and XFSQA test 182 failures...." thread on the mailing list
> from 2008, can someone point me to the commit that eventually resulted
> from that?

I think I may have figured it out.

I assume this was part of the impetus for the patch series from Jan Kara 
starting with "[PATCH 0/8] Sync fixes and cleanups (version 4)" that 
went into 2.6.31.

Thanks,
Chris

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
