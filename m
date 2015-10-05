Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AF1087F37
	for <xfs@oss.sgi.com>; Mon,  5 Oct 2015 18:04:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B59F1304043
	for <xfs@oss.sgi.com>; Mon,  5 Oct 2015 16:03:58 -0700 (PDT)
Received: from g2t4619.austin.hp.com (g2t4619.austin.hp.com [15.73.212.82]) by
	cuda.sgi.com with ESMTP id WXx7pcum8ctW5pOt (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 05 Oct 2015 16:03:57 -0700 (PDT)
Message-ID: <561301DB.8090100@hpe.com>
Date: Mon, 05 Oct 2015 19:03:55 -0400
From: Waiman Long <waiman.long@hpe.com>
MIME-Version: 1.0
Subject: Re: [PATCH] percpu_counter: return precise count from
	__percpu_counter_compare()
References: <201510030251.LfYJ2hol%fengguang.wu@intel.com>
In-Reply-To: <201510030251.LfYJ2hol%fengguang.wu@intel.com>
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
To: kbuild test robot <lkp@intel.com>
Cc: Scott J Norton <scott.norton@hpe.com>, Christoph Lameter <cl@linux-foundation.org>, Douglas Hatch <doug.hatch@hpe.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, kbuild-all@01.org, Tejun Heo <tj@kernel.org>

On 10/02/2015 02:04 PM, kbuild test robot wrote:
> Hi Waiman,
>
> [auto build test results on v4.3-rc3 -- if it's inappropriate base, please ignore]
>
> config: ia64-allnoconfig (attached as .config)
> reproduce:
>          wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # save the attached .config to linux build tree
>          make.cross ARCH=ia64
>
> All error/warnings (new ones prefixed by>>):
>
>

Sorry for the build error. There was a typo in the non-SMP portion of 
the code change. I will fix that in the next version.

Cheers,
Longman

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
