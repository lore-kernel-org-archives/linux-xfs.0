Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 617837F3F
	for <xfs@oss.sgi.com>; Tue, 10 Mar 2015 12:37:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2F0D48F8092
	for <xfs@oss.sgi.com>; Tue, 10 Mar 2015 10:37:06 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id pyyjYixbpMpznrzD for <xfs@oss.sgi.com>;
	Tue, 10 Mar 2015 10:37:04 -0700 (PDT)
Message-ID: <54FF2BBF.7060404@sandeen.net>
Date: Tue, 10 Mar 2015 13:37:03 -0400
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_repair: junk last entry in sf dir if name starts
	beyond dir size
References: <54FDFEDC.5090106@sandeen.net>
	<1061986380.422955.1426008424991.JavaMail.zimbra@rvx.is>
In-Reply-To: <1061986380.422955.1426008424991.JavaMail.zimbra@rvx.is>
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
To: Rui Gomes <rgomes@rvx.is>
Cc: xfs <xfs@oss.sgi.com>

On 3/10/15 1:27 PM, Rui Gomes wrote:
> Hello Eric, 
> 
> I clone the xfs git "git://oss.sgi.com/xfs/cmds/xfsprogs" and I couldn't find the code in any of the branch's
> Is the code in a public available git?

The latest userspae code is currently at git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

The patch I sent applies on top of that, it's not yet been committed to the repo.
The patch as sent should get you through your segfault, but we'll probably end
up merging something a bit different.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
