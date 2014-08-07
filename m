Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 978057F6C
	for <xfs@oss.sgi.com>; Thu,  7 Aug 2014 09:45:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8684A8F8040
	for <xfs@oss.sgi.com>; Thu,  7 Aug 2014 07:45:41 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 2L2lFwDxSEGifOpZ for <xfs@oss.sgi.com>;
	Thu, 07 Aug 2014 07:45:39 -0700 (PDT)
Message-ID: <53E39117.4090200@sandeen.net>
Date: Thu, 07 Aug 2014 09:45:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Recovery of deleted files/directories
References: <CACyNnZNAZUSf1Veybw24hU0snaTyp+Yg+wXS1_Kv-rynQjzjuw@mail.gmail.com>
In-Reply-To: <CACyNnZNAZUSf1Veybw24hU0snaTyp+Yg+wXS1_Kv-rynQjzjuw@mail.gmail.com>
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
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>, xfs@oss.sgi.com

On 8/7/14, 8:41 AM, Felipe Monteiro de Carvalho wrote:
> On Thu, Aug 7, 2014 at 2:56 PM, Brian Foster <bfoster@redhat.com> wrote:
>>> But di_mode in particular is a key element as I am using it to
>>> differentiate files from directories.
>> In general you can't rely on on-disk data once the inode has been freed.
>> Perhaps you should start a new thread with some kind of write up about
>> what you're trying to accomplish and how you're going about it.
> 
> Yes, I know it is unreliable, and that's OK for me. I'm satisfied in
> having a best effort solution which works often, it does not have to
> be fully reliable.
> 
> What I am trying to accomplish is quite simple: Recover as many
> deleted files in a XFS partition as possible. For example if someone
> deletes a file by mistake, how to get it back?

Do you have a link to the project you're working on?  Is it an open
source tool?

There's another tool out there already called "xfs_irecover" which
looks for any inode anywhere on disk, and tries to copy back out any
data that it points to, deleted or not.  It could use some love.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
