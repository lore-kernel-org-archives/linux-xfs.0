Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q94IwsYF196465 for <xfs@oss.sgi.com>; Thu, 4 Oct 2012 13:58:54 -0500
Received: from mail-vb0-f53.google.com (mail-vb0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id QfSgGcu1oCCgfn4L
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 04 Oct 2012 12:00:19 -0700 (PDT)
Received: by mail-vb0-f53.google.com with SMTP id fc21so954851vbb.26
	for <xfs@oss.sgi.com>; Thu, 04 Oct 2012 12:00:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <506DD589.2010106@tlinx.org>
References: <506DAB8C.9000601@tlinx.org>
	<CAGpXXZJuWRAMnJfZKJMZ3N=0EwcfYOEwX+iteyk9hY7ojWA+XA@mail.gmail.com>
	<506DD589.2010106@tlinx.org>
From: Greg Freemyer <greg.freemyer@gmail.com>
Date: Thu, 4 Oct 2012 14:59:48 -0400
Message-ID: <CAGpXXZKHBrZ5qtwpzfSqhPucK8gLvGX5HnXA7-FQcqzLZwvkzw@mail.gmail.com>
Subject: Re: get filename->inode mappings in bulk for a live fs?
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
To: Linda Walsh <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Oct 4, 2012 at 2:29 PM, Linda Walsh <xfs@tlinx.org> wrote:
>> So quiesce system is typically:
>>    - quiesce apps (many enterprise apps provide a API call for this)
>
> ----
>    Can you name 1 on linux that does?
>
>    I can't think of any -- sendmail, imap, samba, squid, syslog...


Commercial - Oracle, DB2 (from IBM)

opensource -
   sendmail has a quiesce signal handler, but I've never used it

        see sendmail.h
        extern SIGFUNC_DECL	quiesce __P((int));

   Postgres and mysql fake it I think,  You "quiesce" them by having
them do a dump of the database, then the backup picks up the dump.

The key thing is knowing the right word to google for, and the right
word is quiesce.

Greg

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
