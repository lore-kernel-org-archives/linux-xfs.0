Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33812 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728699AbeKOWsW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Nov 2018 17:48:22 -0500
Received: by mail-wr1-f65.google.com with SMTP id j26-v6so21067445wre.1
        for <linux-xfs@vger.kernel.org>; Thu, 15 Nov 2018 04:40:39 -0800 (PST)
MIME-Version: 1.0
References: <20181109143004.24963-1-jtulak@redhat.com> <9a951869-5852-2689-a6ef-084c770f16fb@sandeen.net>
In-Reply-To: <9a951869-5852-2689-a6ef-084c770f16fb@sandeen.net>
From: Jan Tulak <jtulak@redhat.com>
Date: Thu, 15 Nov 2018 13:40:26 +0100
Message-ID: <CACj3i70u6hS2RgSRwHMqLZtKexdEz6GnSH10tyYF6DiHXimnug@mail.gmail.com>
Subject: Re: [PATCH 00/24] xfsdump: code style change
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Wed, Nov 14, 2018 at 9:36 PM Eric Sandeen <sandeen@sandeen.net> wrote:
>
> On 11/9/18 8:29 AM, Jan Tulak wrote:
> > This set is dealing with whitespaces only, no functional change, code
> > shuffling, etc. should be present (with one small exception in patch no. 2).
> > From the previous set I split the changes into multiple patches, one type of
> > change at a time, and tried to make the code fully compliant with xfs style,
> > so the number of changes is way bigger than in the first set.
> >
> > The only patch with code shuffling (but no behavioral change) is: "xfsdump: do
> > not split function call with ifdef." See the patch for details.
> >
> > For patch 21 - xfsdump: (style) format intercharacter spaces, I think whether
> > it is still to much agregated and I should separate the changes. Some other
> > patches I had to split to multiple files as they are too big to pass through
> > to the mailing list - it is in their name. The largest one is 660K now, so I
> > will check if that passed through, or it is still too big.
> >
> > The whole set is created mechanically from scratch. Scripts used for the
> > specific change are part of the commit message and I can easily put it all
> > together. So there is no need to worry about rebase conflicts, etc. when
> > pointing out issues.
> >
> > The tools used to make these changes are sed and uncrustify.
> > http://uncrustify.sourceforge.net/
> >
> > A git tree with these patches is also on Github:
> > https://github.com/jtulak/xfsdump/tree/style-nov-9th
> > or
> > git clone --single-branch -b style-nov-9th https://github.com/jtulak/xfsdump.git
>
> Thanks for doing this.  I do think it's useful in the long run.
>
> NB: not all patches came through, apparently they were too big for the list.

Thanks for looking at it. And sorry for the missing mails, I checked
it in my mailbox and there they arrived all. But apparently, Gmail and
its deduplication made it look like it came through both mailing list
and me in cc, even if I received CCed version only.

>
> A few issues I notice:
>
> 1) we now get warnings like:
>
> In file included from content.c:44:0:
> types.h:30:0: warning: "sizeofmember" redefined [enabled by default]
>  #define sizeofmember(t, m)      sizeof(((t *)0)->m)
>  ^
> In file included from content.c:40:0:
> /usr/include/xfs/jdm.h:65:0: note: this is the location of the previous definition
>  #define sizeofmember( t, m ) sizeof( ( ( t * )0 )->m )
>  ^
>
> because xfsprogs headers have the definitions w/ the spaces in them.  So
> I'd just leave sizeofmember and offsetofmember defines alone for now to
> avoid this.  Or, wrap them in #ifndef's.  Or if we require xfsprogs headers
> to build anyway, perhaps just drop the defines altogether.

Ok, I will drop it out.

>
> 2) I think we probably do not want to change any user-facing strings,
> or at least they should be carefully examined.  This will break some
> translations (fixable) but it's also more of a functional change, and
> should be done with care if at all, and maybe left for a separate patch
> if it's warranted.
>
> 3) This creates /many/ more > 80 char lines.  Per:
>
> # for F in */*.[ch]; do expand $F | grep '.\{81\}'; done
>
> the codebase goes from 794 such lines to 1806.  IOWs, some of the "missing"
> whitespace may have been intentional, to stay under 80 cols.  New lines
> vs. compressed lines is a judgement call, I guess.  Bleah.
>
> So... sorry about that, but if the goal is to format better, let's be
> sure to keep observing other basic rules like "< 80 cols"

Yeah. I'm not sure there is an easy way to automate that...

>
> 4) related, there are places where we intentionally dropped a space to
> keep things well aligned, for example:
>
>         ULO(_("<file> (restore only if newer than)"),   GETOPT_NEWER);
>         ULO(_("(restore owner/group even if not root)"),GETOPT_OWNER);
>         ULO(_("<seconds between progress reports>"),    GETOPT_PROGRESS);
>
> this "breaks the rule" but it's fairly common to line up columns that way
> if it's just off by 1 char.
>
> Other things like this:
>
>  struct quota_info {
> -       char *  desc;           /* Quotas type (user, project, etc) */
> -       bool_t  savequotas;     /* Quotas saved OK */
> -       char *  quotafile;      /* Filename quota info is stored in */
> -       char    quotapath[MAXPATHLEN]; /* Full path to quotafile */
> -       char *  repquotaargs;   /* Args to repquota to create this quotafile */
> -       int     statflag;       /* quota stats flag for this type */
> -       ino_t   quotaino;       /* ino of the quota file */
> +       char *  desc;                   /* Quotas type (user, project, etc) */
> +       bool_t  savequotas;             /* Quotas saved OK */
> +       char *  quotafile;              /* Filename quota info is stored in */
> +       char    quotapath[MAXPATHLEN];  /* Full path to quotafile */
> +       char *  repquotaargs;           /* Args to repquota to create this quotafile */
> +       int     statflag;               /* quota stats flag for this type */
> +       ino_t   quotaino;               /* ino of the quota file */
>  };
>
> probably shouldn't happen either, it's better to keep stuff < 80cols
> and have 1 oddball comment remaining.
>
> I was trying to compare objdump -d to ensure there were no other unintended
> runtime changes, but unfortunately there are changes
> which will affect that even if it's whitespace; for example whitespace
> changes within an assert() will change strings (the text of the assert)
> and their locations, and so will change the disassembly.  So I'm not sure
> it's possible to validate "no functional changes" by binary inspection...
>
> I suppose we could try to limit whitespace changes to things that won't
> change disassembly first (for example, no string or assert changes) and
> then go back and do them, so that we could ge the bulk of the changes in
> with no modifications to the binary code, but ... I'm not sure if it's
> worth it.

I'll look at these issues and see what can be done/if that helps with
disassembly.

>
> Sorry for the hassle, but even though it's "only whitespace" I think we
> want to be as careful as possible to not move anything backwards...

Yup, I agree. We are not talking about a web form that will work even
if the layout breaks a bit.

Thanks,
Jan
