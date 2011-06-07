Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p571fSI4258205 for <xfs@oss.sgi.com>; Mon, 6 Jun 2011 20:41:28 -0500
Received: from e36.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5ECE24A00FF
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2011 18:41:28 -0700 (PDT)
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154]) by
	cuda.sgi.com with ESMTP id cnGSBygJaM4bi0LJ for
	<xfs@oss.sgi.com>; Mon, 06 Jun 2011 18:41:28 -0700 (PDT)
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com
	[9.17.195.107])
	by e36.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p571ZWL1007802
	for <xfs@oss.sgi.com>; Mon, 6 Jun 2011 19:35:32 -0600
Received: from d03av06.boulder.ibm.com (d03av06.boulder.ibm.com [9.17.195.245])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p571fNpX361608 for <xfs@oss.sgi.com>; Mon, 6 Jun 2011 19:41:24 -0600
Received: from d03av06.boulder.ibm.com (loopback [127.0.0.1])
	by d03av06.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p571kcu7001787
	for <xfs@oss.sgi.com>; Mon, 6 Jun 2011 19:46:38 -0600
Message-ID: <4DED81C1.6000204@vnet.ibm.com>
Date: Mon, 06 Jun 2011 18:41:21 -0700
From: Allison Henderson <achender@vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/3 v5] XFS TESTS: Add Punch Hole to FSX
References: <4DED63D1.5010600@vnet.ibm.com> <20110607004445.GG20818@thunk.org>
In-Reply-To: <20110607004445.GG20818@thunk.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ted Ts'o <tytso@mit.edu>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On 06/06/2011 05:44 PM, Ted Ts'o wrote:
> Hey Allison, there are two things you can do that will make life much
> easier for people to review and apply your patches.  First of all,
> move the version information below to after the "---" line.  If you
> want to keep this information in the git commit log, just move the
> "---" line after you run the "git format-patch" command.
>
> Secondly, run the command "git config format.thread true"; this is the
> default in newer versions of git, but apparently you're not using a
> new enough version of git.  You can also use "git send-email --thread"
> if you don't want to set the git configuration variable.  The other
> possibility is that your mailer is stripping the in-reply-to: and
> references: header, so the mail threading is disappearing.  I never
> used vnet.ibm.com's mailer, so I don't know if it's responsible for
> stripping mail headers, but I tend not to trust VM or Lotus Notes'
> standard adherence... fortunately for IBM the CIO's who make the
> purchasing decisions tend not to know the first thing about Internet
> Mail Standers or RFC's.:-)
>
> 		       	      	- Ted


Thx Ted!  I didn't realize the patches were hard for people to read.  I 
will see if I can get those commands to work, and I will make sure the 
"---" comes before the version info.  Initially I had tried the 
send-email, but not all of the patches seemed to make it to the lists, 
so I started using Thunderbird, but I will see if I can figure out what 
went wrong with send-email.  Thx!

Allison Henderson

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
