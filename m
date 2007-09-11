Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 11 Sep 2007 11:02:47 -0700 (PDT)
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.169])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8BI2e4p023113
	for <linux-xfs@oss.sgi.com>; Tue, 11 Sep 2007 11:02:43 -0700
Received: by ug-out-1314.google.com with SMTP id m3so118186ugc
        for <linux-xfs@oss.sgi.com>; Tue, 11 Sep 2007 11:02:42 -0700 (PDT)
Message-ID: <cc7060690709111033s4cfa5ederd44dde2363500e5e@mail.gmail.com>
Date: Tue, 11 Sep 2007 23:03:41 +0530
From: "Bhagi rathi" <jahnu77@gmail.com>
Subject: Re: getfattr and symlinks
In-Reply-To: <46E52F95.3070307@redhat.com>
MIME-Version: 1.0
References: <46E52F95.3070307@redhat.com>
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Zdenek Prikryl <zprikryl@redhat.com>
Cc: linux-xfs@oss.sgi.com

My understanding on man pages says that it doesn't follow the symlink.
Note that a symlink file itself can also have extended attributes. Unless
specified,
getfattr should just try to extract extended attributes of the symbolic link
file itself.

-Saradhi.

On 9/10/07, Zdenek Prikryl <zprikryl@redhat.com> wrote:
>
> Hello,
> I have one question, what is right behavior of getfattr in a recursive
> mode? Should getfattr follow symlinks in this mode (without [PLh]
> parameters)?
>
> Example:
>
> $HOME/file.txt
> $HOME/symlink -> /
> ...
>
> getfattr -Rd $HOME
>
> So what is the right result? Follow "$HOME/symlink" or not?
>
> Thank you
>
> Zdenek Prikryl
>
>
>


[[HTML alternate version deleted]]
