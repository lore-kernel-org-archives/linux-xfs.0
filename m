Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1C9527F50
	for <xfs@oss.sgi.com>; Thu,  6 Mar 2014 14:31:02 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 01EEB8F806F
	for <xfs@oss.sgi.com>; Thu,  6 Mar 2014 12:30:58 -0800 (PST)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id esHFUkqWcPN2TfOj
	for <xfs@oss.sgi.com>; Thu, 06 Mar 2014 12:30:54 -0800 (PST)
Message-ID: <5318DB01.2040102@hardwarefreak.com>
Date: Thu, 06 Mar 2014 14:30:57 -0600
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Hello, I have a question about XFS File System
References: <195DE8C60CE24A62A71911FDE0B0DC97@gmail.com>
In-Reply-To: <195DE8C60CE24A62A71911FDE0B0DC97@gmail.com>
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
To: Yongmin <dev.yongmin@gmail.com>, xfs@oss.sgi.com

On 3/6/2014 3:15 AM, Yongmin wrote:
> 
> Hello.
> 
> My name is Yongmin Park and I am a graduated student in Ajou
> University (Korea). My research area is Digital Forensics. And this
> time i tried to understand the structure of XFS file system, because
> XFS is one of the famous huge file system in these days.
> 
> I already founded and read 'XFS Filesystem Structure 2nd Edition
> Revision 1' on the Internet, which was written by Silicon Graphics
> Inc in 2006 and it is really well written to understand.
> 
> But the concentrated part of mine is "Deleted File Recovery", so the
> Journaling part is really important for me,, but regretfully there
> are no specific guide line about Journaling part... Also next
> version(maybe the 3re Edition) is not exsist for more than a 5
> years.
> 
> So is there no guide line for journaling part in XFS? How can i get
> them,, have I to buy them? or Is Analysing Source Cord only way to
> study?

The journal only contains in flight transactional metadata for recovery
purposes after a system crash or power loss, to prevent filesystem, i.e.
metadata, corruption.  The journal does not contain file data.  During
normal operation, once the metadata has been written into an allocation
group the transactional entry in the journal is removed.  Thus,
recovering deleted files has nothing to do with the journal.

This may be helpful:
http://xfs.org/index.php/XFS_FAQ#Q:_Does_the_filesystem_have_an_undelete_capability.3F

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
