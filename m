Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9969C29DF8
	for <xfs@oss.sgi.com>; Thu,  2 Jan 2014 09:07:10 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 71FAF304051
	for <xfs@oss.sgi.com>; Thu,  2 Jan 2014 07:07:10 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id dtdovFqVdezNqnZx
	for <xfs@oss.sgi.com>; Thu, 02 Jan 2014 07:07:06 -0800 (PST)
Message-ID: <52C58095.70408@hardwarefreak.com>
Date: Thu, 02 Jan 2014 09:07:01 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS File System Monitor
References: <CA+apj_hV4HvZxfASF7JJ1k6mmvio3cRWAHj-S1V=Vm8X_RWA=Q@mail.gmail.com>
In-Reply-To: <CA+apj_hV4HvZxfASF7JJ1k6mmvio3cRWAHj-S1V=Vm8X_RWA=Q@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
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
To: Rotem Ben Arye <rotem.benarye@gmail.com>, support@sgi.com
Cc: xfs@oss.sgi.com

On 1/2/2014 6:16 AM, Rotem Ben Arye wrote:
> Hi, SGI Support Team.
> My Name is Rotem , I am a Linux/Unix System Administrator in web company at
> Israel.
> I have a question I want to appeal to you to get some advice.
> 
> In the last weekend we had crisis in one of the Production server in
> the comany ,the problem was defined by the Integrators as  "xfs file system
> corrupted"
> My question is , what are the open source tools , that we can use on
> runtime at production environment , to monitor and sample to get indication
> on mount XFS ,
> That something is not living well, and can lead to problem.
> 
> We are working in a Linux environment on CentOS distributions server.

So in a nutshell you're looking for a monitor application that will in
essence give you a green, yellow, or red light informing you of the
filesystem's health.  Or some kind of SNMP logging that suggests a
corruption is imminent.

There is no such tool, and never will be.  Nearly all XFS corruption
events are caused by either software bugs in the XFS code or elsewhere
in the Linux kernel, transient or permanent hardware failures, or power
failures, at some layer in the storage stack.  It is not feasible to
predict such events.

When an XFS corruption occurs, one should report all related log
information and errors to this list so that the problem may be analyzed
and the root cause identified.  Then the proper corrective action can be
identified and implemented to fix the problem and hopefully prevent it
from reoccurring.

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
