Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q22GI9sC099481 for <xfs@oss.sgi.com>; Fri, 2 Mar 2012 10:18:09 -0600
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id qIDJokzb1FFK0P9E for
	<xfs@oss.sgi.com>; Fri, 02 Mar 2012 08:18:07 -0800 (PST)
Date: Fri, 2 Mar 2012 16:18:08 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: [XFS] xfs_repair time how long it takes??
Message-ID: <20120302161808.GD12352@nsrc.org>
References: <CABF-5WptGU3vmScFcpHVstd2UZfCAqiY4dGvL=_1+feFvYuS6g@mail.gmail.com>
	<20120302140145.GA11911@nsrc.org>
	<37B5727D-1E3B-4A96-BF7F-4CA6DAF9B63C@gmail.com>
	<4F50E246.4020502@sandeen.net>
	<CABF-5Wo1BRGgiy89PO+6sXzZ5ggFJYAXtXu+DA9hbEvfazFNqw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CABF-5Wo1BRGgiy89PO+6sXzZ5ggFJYAXtXu+DA9hbEvfazFNqw@mail.gmail.com>
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
To: Ryan Lee <ryanlee.lahk@gmail.com>
Cc: xfs@oss.sgi.com

On Sat, Mar 03, 2012 at 12:48:06AM +0900, Ryan Lee wrote:
>    You guys told me to use  the "fsck.xfs".

No I didn't - I linked to the manpage.  If you read it, you will see that it
says it does nothing at all.

It is purely a placeholder, for Linux systems which try to do fsck.<foo>
whenever they mount a filesystem of type <foo>.

The point is, you don't need it.

>    Onething more, I already know about the problem with "xfs_repair", but
>    I cound't find any other good solution to fix it until now.
> 
>    How can I fix it?

Probably you need to stop your journal from getting corrupted in the first
place.  See the XFS FAQ:

http://xfs.org/index.php/XFS_FAQ#Q:_What_is_the_problem_with_the_write_cache_on_journaled_filesystems.3F

and the following 5 questions and answers.  In particular make sure your
block driver has working write barrier support.

Final note: please don't reply to me without replying to the list as well. I
have been forwarding your replies to the list, but it is annoying to have to
do so.  Your mail client probably has a 'reply to list' or 'group reply'
function you can use.

Regards,

Brian.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
