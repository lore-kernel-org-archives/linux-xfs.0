Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DA2DC7F7C
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 07:38:27 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C7F438F8037
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2014 05:38:24 -0800 (PST)
Received: from mail-qg0-f46.google.com (mail-qg0-f46.google.com
	[209.85.192.46]) by cuda.sgi.com with ESMTP id DUOk3fQDBVBoXrcG
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 04 Nov 2014 05:38:23 -0800 (PST)
Received: by mail-qg0-f46.google.com with SMTP id i50so9431610qgf.33
	for <xfs@oss.sgi.com>; Tue, 04 Nov 2014 05:38:23 -0800 (PST)
Date: Tue, 4 Nov 2014 08:38:20 -0500
From: Tejun Heo <tj@kernel.org>
Subject: Re: [AHCI] XFS (sda3): metadata I/O error: block 0x941ce20
	("xlog_iodone") error 5 numblks 64
Message-ID: <20141104133820.GA13567@htj.dyndns.org>
References: <20141104042522.GA14917@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141104042522.GA14917@wfg-t540p.sh.intel.com>
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
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, lkp@01.org, LKML <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Tue, Nov 04, 2014 at 12:25:22PM +0800, Fengguang Wu wrote:
> Hi Tejun,
> 
> FYI, we noticed the below changes on
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tj/libata for-3.18-fixes
> commit 61e268068c92ed000f078dc1ab71d1228439fecd ("Revert "AHCI: Optimize single IRQ interrupt processing"")

Yeah, there's a dependent revert that I missed.  libata/for-3.18-fixes
has been rebased, so this shouldn't happen anymore.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
