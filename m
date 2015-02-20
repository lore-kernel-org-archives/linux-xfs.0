Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E93CD7F5F
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2015 04:36:49 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 64733AC002
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2015 02:36:49 -0800 (PST)
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72]) by
	cuda.sgi.com with ESMTP id bq4C9MVD74dzeeYg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 20 Feb 2015 02:36:46 -0800 (PST)
Subject: Re: How to handle TIF_MEMDIE stalls?
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201502172123.JIE35470.QOLMVOFJSHOFFt@I-love.SAKURA.ne.jp>
	<20150217125315.GA14287@phnom.home.cmpxchg.org>
	<20150217225430.GJ4251@dastard>
	<20150219102431.GA15569@phnom.home.cmpxchg.org>
	<20150219225217.GY12722@dastard>
In-Reply-To: <20150219225217.GY12722@dastard>
Message-Id: <201502201936.HBH34799.SOLFFFQtHOMOJV@I-love.SAKURA.ne.jp>
Date: Fri, 20 Feb 2015 19:36:33 +0900
Mime-Version: 1.0
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
To: david@fromorbit.com, hannes@cmpxchg.org
Cc: dchinner@redhat.com, oleg@redhat.com, xfs@oss.sgi.com, mhocko@suse.cz, linux-mm@kvack.org, mgorman@suse.de, rientjes@google.com, akpm@linux-foundation.org, torvalds@linux-foundation.org

Dave Chinner wrote:
> I really don't care about the OOM Killer corner cases - it's
> completely the wrong way line of development to be spending time on
> and you aren't going to convince me otherwise. The OOM killer a
> crutch used to justify having a memory allocation subsystem that
> can't provide forward progress guarantee mechanisms to callers that
> need it.

I really care about the OOM Killer corner cases, for I'm

  (1) seeing trouble cases which occurred in enterprise systems
      under OOM conditions

  (2) trying to downgrade OOM "Deadlock or Genocide" attacks (which
      an unprivileged user with a login shell can trivially trigger
      since Linux 2.0) to OOM "Genocide" attacks in order to allow
      OOM-unkillable daemons to restart OOM-killed processes

  (3) waiting for a bandaid for (2) in order to propose changes for
      mitigating OOM "Genocide" attacks (as bad guys will find how to
      trigger OOM "Deadlock or Genocide" attacks from changes for
      mitigating OOM "Genocide" attacks)

I started posting to linux-mm ML in order to make forward progress
about (1) and (2). I don't want the memory allocation subsystem to
lock up an entire system by indefinitely disabling memory releasing
mechanism provided by the OOM killer.

> I've proposed a method of providing this forward progress guarantee
> for subsystems of arbitrary complexity, and this removes the
> dependency on the OOM killer for fowards allocation progress in such
> contexts (e.g. filesystems). We should be discussing how to
> implement that, not what bandaids we need to apply to the OOM
> killer. I want to fix the underlying problems, not push them under
> the OOM-killer bus...

I'm fine with that direction for new kernels provided that a simple
bandaid which can be backported to distributor kernels for making
OOM "Deadlock" attacks impossible is implemented. Therefore, I'm
discussing what bandaids we need to apply to the OOM killer.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
