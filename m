Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB6FGlkG233434 for <xfs@oss.sgi.com>; Tue, 6 Dec 2011 09:16:47 -0600
Received: from mail.in8.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E89D229EB0F
	for <xfs@oss.sgi.com>; Tue,  6 Dec 2011 07:16:46 -0800 (PST)
Received: from mail.in8.de (brockman.in8.de [85.214.220.56]) by cuda.sgi.com
	with ESMTP id HUBuRhSzxfinaD5Q for <xfs@oss.sgi.com>;
	Tue, 06 Dec 2011 07:16:46 -0800 (PST)
Message-ID: <4EDE31DD.3000401@jan-o-sch.net>
Date: Tue, 06 Dec 2011 16:16:45 +0100
From: Jan Schmidt <mail@jan-o-sch.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: check if qa user can execute commands
References: <1323165389-5419-1-git-send-email-list.btrfs@jan-o-sch.net>
	<20111206151300.GA11874@infradead.org>
In-Reply-To: <20111206151300.GA11874@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-btrfs@vger.kernel.org, Jan Schmidt <list.btrfs@jan-o-sch.net>, xfs@oss.sgi.com

On 06.12.2011 16:13, Christoph Hellwig wrote:
> On Tue, Dec 06, 2011 at 10:56:29AM +0100, Jan Schmidt wrote:
>> _require_user only checks if the qa user exists in /etc/passwd. It may exist
>> though still not be able to execute anything (e.g. with a /bin/false shell).
>>
>> _user_do cannot determine failure to execute the given command, as it uses
>> _user_do_filter for post-processing which succeeds even if the command
>> fails. Thus, the check should be performed by _require_user.
> 
> Looks good.  Wouldn't
> 
> 	su $qa_user -c /bin/true
> 
> be the more normal way to write that test?

I agree. I saw this and thought I'd adapt the (sometimes strange)
predominant bash programming style:

 921 _user_do()
 922 {
 923     if [ "$HOSTOS" == "IRIX" ]
 924         then
 925         echo $1 | /bin/bash "su $qa_user 2>&1" | _filter_user_do
 926     else
 927         echo $1 | su $qa_user 2>&1 | _filter_user_do
 928     fi
 929 }

-Jan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
