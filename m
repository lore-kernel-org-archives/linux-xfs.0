Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAHJT2uo069242 for <xfs@oss.sgi.com>; Thu, 17 Nov 2011 13:29:02 -0600
Message-ID: <1321558138.3015.4.camel@doink>
Subject: Re: [patch] xfsprogs - workaround debian build daemon dependency
	resolution
From: Alex Elder <aelder@sgi.com>
Date: Thu, 17 Nov 2011 13:28:58 -0600
In-Reply-To: <CAAp5ZgPntg0f+edJQFU8n0npBT1+46NqwwiUEtLXZPJoLwVL1g@mail.gmail.com>
References: <CAAp5ZgPntg0f+edJQFU8n0npBT1+46NqwwiUEtLXZPJoLwVL1g@mail.gmail.com>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Nathan Scott <nathans@debian.org>
Cc: xfs@oss.sgi.com

On Tue, 2011-11-15 at 20:39 +1100, Nathan Scott wrote:
> Workaround the Debian buildd dependency handling for libreadline5 library
> handling
> 
> Evidently the buildd daemons process depenencies differently to local
> builds, and
> expect the first of optional dependencies to be resolved.  Flip the
> ordering to match
> this dependency.
> 
> Signed-off-by: Nathan Scott <nathans@debian.org>

Looks fine to me.

Signed-off-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
