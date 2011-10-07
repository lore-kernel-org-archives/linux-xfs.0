Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p970M8Lq209056 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 19:22:08 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7DFA51B457A
	for <xfs@oss.sgi.com>; Thu,  6 Oct 2011 17:22:06 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id 1nGgA3SY4GiFhcA8
	for <xfs@oss.sgi.com>; Thu, 06 Oct 2011 17:22:06 -0700 (PDT)
Message-ID: <4E8E4630.8030108@hardwarefreak.com>
Date: Thu, 06 Oct 2011 19:22:08 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Premature "No Space left on device" on XFS
References: <4E8E079B.4040103@birkenwald.de>
In-Reply-To: <4E8E079B.4040103@birkenwald.de>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Bernhard Schmidt <berni@birkenwald.de>
Cc: xfs@oss.sgi.com

On 10/6/2011 2:55 PM, Bernhard Schmidt wrote:
> Hi,
> 
> this is an XFS-related summary of a problem report I sent to the postfix
> mailinglist a few minutes ago after a bulkmail test system blew up
> during a stress test.
> 
> We have a few MTAs running SLES11.1 amd64 (2.6.32.45-0.3-default), 10 GB
> XFS Spooldirectory with default blocksize (4k). It was bombarded with
> mails faster than it could send them on, which eventually led to almost
> 2 million files of ~1.5kB in one directory. Suddenly, this started to
> happen
> 
> lxmhs45:/var/spool/postfix-bulk/postfix-bulkinhss # touch a
> touch: cannot touch `a': No space left on device
> lxmhs45:/var/spool/postfix-bulk/postfix-bulkinhss # df .
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/sdb              10475520   7471160   3004360  72%
> /var/spool/postfix-bulk
> lxmhs45:/var/spool/postfix-bulk/postfix-bulkinhss # df -i .
> Filesystem            Inodes   IUsed   IFree IUse% Mounted on
> /dev/sdb             10485760 1742528 8743232   17% /var/spool/postfix-bulk
> 
> So we could not create any file in the spool directory anymore despite
> df claiming to have both free blocks and inodes. This led to a pretty
> spectacular lockup of the mail processing chain.
> 
> My theory is that XFS is using a full 4k block for each 1.5kB file,
> which accounts to some loss. But still, 10GB / 4kB makes 2.5 mio files,
> which have surely not been reached here. Is there that high overhead?
> Why is neither df-metric reporting this problem? Is there any way to get
> reasonable readings out of df in this case? The system would have
> stopped accepting mail from outside if the freespace would have sunk
> below 2GB, so out-of-space happened way to early for it.

Dig deeper so you can get past theory and find facts.  Do you see any
errors in dmseg?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
