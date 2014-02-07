Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EF74C7F4E
	for <xfs@oss.sgi.com>; Fri,  7 Feb 2014 09:57:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D1B4630408C
	for <xfs@oss.sgi.com>; Fri,  7 Feb 2014 07:57:42 -0800 (PST)
Received: from cdptpa-oedge-vip.email.rr.com
	(cdptpa-outbound-snat.email.rr.com [107.14.166.226]) by
	cuda.sgi.com with ESMTP id 24yXcjQVbemSUY5q for
	<xfs@oss.sgi.com>; Fri, 07 Feb 2014 07:57:41 -0800 (PST)
Date: Fri, 7 Feb 2014 10:57:40 -0500
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [GIT PULL] XFS fix for 3.14-rc2
Message-ID: <20140207155740.GB6857@home.goodmis.org>
References: <20140206173158.6A2A14266DC@whiskey.americas.sgi.com>
	<CA+55aFzxUtHWL1hPcNv-zUXFWzrZtKAsh_ZVotfFUvH1hqDrMg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFzxUtHWL1hPcNv-zUXFWzrZtKAsh_ZVotfFUvH1hqDrMg@mail.gmail.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Thu, Feb 06, 2014 at 01:34:53PM -0800, Linus Torvalds wrote:
> I have no idea why you keep re-sending this.
> 
> It got merged a week ago. See commit f1499382f114.
> 

Ben, you might want to subscribe to git-commits-head@vger.kernel.org
and then add this to your .procmailrc:

:0 H
* List-id: <git-commits-head.vger.kernel.org>
{
        :0 B
        * !Signed-off-by: Ben Myers <bpm@sgi.com>
        /dev/null

        :0 fw
        | /bin/sed -e 's/^Subject: /Subject: [linus-commit]/'
}


Then you get a nice email when your commits are added to Linus's tree.

-- Steve

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
