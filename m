Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:15475 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbeI1Fdx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Sep 2018 01:33:53 -0400
Subject: Re: Leaking Path in XFS's ioctl interface(missing LSM check)
References: <5EF0D46A-C098-4B51-AD13-225FFCA35D4C@vt.edu>
 <20180926013329.GD31060@dastard> <20180926192426.472360ea@alans-desktop>
 <20180927013812.GF31060@dastard>
 <alpine.LRH.2.21.1809280720330.8410@namei.org>
 <20180927221948.GH31060@dastard>
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-ID: <43032103-99c5-88ae-5aa1-a7906e059a8b@I-love.SAKURA.ne.jp>
Date: Fri, 28 Sep 2018 08:12:41 +0900
MIME-Version: 1.0
In-Reply-To: <20180927221948.GH31060@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>
Cc: Alan Cox <gnomes@lxorguk.ukuu.org.uk>, TongZhang <ztong@vt.edu>, darrick.wong@oracle.com, linux-xfs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, Wenbo Shen <shenwenbosmile@gmail.com>

On 2018/09/28 7:19, Dave Chinner wrote:> IOWs, the security_file_ioctl() hook is almost completely useless in
> cases like this - you can't isolate the ioctl based on the file
> argument, because it can point to any file or directory in the
> filesystem. And without actually parsing, decoding and instantiating
> the the ioctl arguments, you can't tell the ioctl it can't act on
> specific targets. And because filehandle to dentry resolution
> results in disconnected dentries, the paths are not complete and
> hence path based security checks (e.g. tomoyo) are likely to be
> broken and unfixable...

Though TOMOYO uses pathname as a mandatory parameter, CaitSith
(currently waiting for review) does not.

CaitSith can filter filesystem specific ioctl() using fsmagic
and cmd parameter like:

10 acl ioctl path.fsmagic=0x9FA0
    audit 0
    10 deny cmd=@FORBIDDEN_IOCTLS_ON_PROCFS
    20 allow

CaitSith does ioctl() checks. Missing LSM check is a bug.
