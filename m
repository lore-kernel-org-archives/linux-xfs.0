Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4AAJtZn257018 for <xfs@oss.sgi.com>; Mon, 10 May 2010 05:19:55 -0500
Received: from mx03.kabsi.at (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 04740327D0F
	for <xfs@oss.sgi.com>; Mon, 10 May 2010 03:22:05 -0700 (PDT)
Received: from mx03.kabsi.at (mx03.kabsi.at [195.202.128.130]) by cuda.sgi.com
	with ESMTP id 3DTmcBhVldyyL8XV for <xfs@oss.sgi.com>;
	Mon, 10 May 2010 03:22:05 -0700 (PDT)
Date: Mon, 10 May 2010 12:22:03 +0200
From: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
Message-ID: <23944308.20100510122203@kaneda.iguw.tuwien.ac.at>
Subject: Re[2]: xfs and raid5 - "Structure needs cleaning for directory open"
In-Reply-To: <4BE7AD82.90300@gmail.com>
References: <20100510022033.GB7165@dastard> <4BE7AD82.90300@gmail.com>
MIME-Version: 1.0
Reply-To: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>
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
To: Mark Goodwin <goodwinos@gmail.com>
Cc: xfs@oss.sgi.com

mark,

yes, thank you, that looks very much like it. CentOS is still at 5.4,
version 5.5 is long overdue :-(

tnx & cu


MG> On 05/10/2010 12:20 PM, Dave Chinner wrote:
>> On Sun, May 09, 2010 at 08:48:00PM +0200, Rainer Fuegenstein wrote:
>>>
>>> today in the morning some daemon processes terminated because of
>>> errors in the xfs file system on top of a software raid5, consisting
>>> of 4*1.5TB WD caviar green SATA disks.
>>
>> Reminds me of a recent(-ish) md/dm readahead cancellation fix - that
>> would fit the symptoms of (btree corruption showing up under heavy IO
>> load but no corruption on disk. However, I can't seem to find any
>> references to it at the moment (can't remember the bug title), but
>> perhaps your distro doesn't have the fix in it?

MG> If it's the bug that Dave's thinking of, it's an issue with md
MG> error handling and the BIO_UPTODATE flag, see :
MG> http://www.mail-archive.com/linux-raid@vger.kernel.org/msg06628.html

MG> For RHEL, this is addressed in Red Hat BZ 512552
MG> https://bugzilla.redhat.com/show_bug.cgi?id=512552

MG> upstream commit c2b00852fbae4f8c45c2651530ded3bd01bde814

MG> Cheers
MG> -- Mark

MG> _______________________________________________
MG> xfs mailing list
MG> xfs@oss.sgi.com
MG> http://oss.sgi.com/mailman/listinfo/xfs


------------------------------------------------------------------------------
Unix gives you just enough rope to hang yourself -- and then a couple of more 
feet, just to be sure.
(Eric Allman)
------------------------------------------------------------------------------

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
