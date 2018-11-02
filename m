Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([150.101.137.136]:54372 "EHLO
        ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726705AbeKCHnj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 3 Nov 2018 03:43:39 -0400
Date: Sat, 3 Nov 2018 09:34:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/2] xfsdump whitespace changes
Message-ID: <20181102223435.GE19305@dastard>
References: <20181101110130.19489-1-jtulak@redhat.com>
 <20181102013618.GD19305@dastard>
 <CACj3i71FUf84iUCFKVhVPQVhjUOdb-_TDTsPVvrFe8hC_zLMeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i71FUf84iUCFKVhVPQVhjUOdb-_TDTsPVvrFe8hC_zLMeg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Fri, Nov 02, 2018 at 12:43:18PM +0100, Jan Tulak wrote:
> On Fri, Nov 2, 2018 at 2:36 AM Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Nov 01, 2018 at 12:01:28PM +0100, Jan Tulak wrote:
> > However, it's is the same change as what you originally posted to a
> 
> Yes, it is the same thing, with changes where I found something
> misaligned on top.
> 
> > git tree, then it needs revision. basically, most of the change was
> > converting vertically aligned function call parameters to use tabs,
> > and that broke the vertical alignment.
> 
> It is "s/    /\t/" limited to the beginning of the line.

You mean 's/^    /\t/'?

Because the above regex is "change the first occurrence anywhere on
the line", not at the start of the line. IIRC, that's what the
original patch did. I can't check, becuase you've removed it from
your git tree... :/

> The function
> parameters were caught in it too, but I don't think they would make
> the most of the lines.

It was enough for me to notice both declarations and call sites made
up a large amount of the change in the first 3rd of the diff I
scrolled through... :/

> > I'd suggest that this is the least of the whitespace sins of
> > xfsdump. yes, it's easy to script, but I don't think it's the right
> > thing to do. The biggest problems I think we need to start with are:
> >
> > - reformat all the function definitions according to common XFS style
> > - get rid of all the "( foo )" style white space aroudn parenthesis
> 
> I already started working on it. It is too complex for awk/sed, so I'm
> trying to find some better way through IDEs with autoformatting
> capabilities.

It should be relatively straight forward with sed. e.g. off the top
of my head, stripping the space after "(" is this expression:

$ echo "foo( bar" | sed -e 's/\([[:alnum:]](\) \([[:alnum:]]\)/\1\2/' 
foo(bar
$

/me is slightly worried that he can now write non-trivial line noise
in sed that does the right thing first go....

Another option is coccinelle - it was specifically designed to do
such semantic transformations to C code:

http://coccinelle.lip6.fr/
http://coccinellery.org/

It's been widely used on the linux kernel for automated, widepsread
code changes for bug fixes and cleanups.

> > - convert all the code with 4 space indents to tabs, leaving
> >   vertically aligned function call parameters alone.
> 
> Part of the issue is that xfsdump is not even consistently using the
> number of spaces. E.g. just a two random functions in
> invutil/stobj.c:335-486 in master, you find that both 2 and 4 spaces
> per indent level are used and even stuff like \t<space*4> inside of
> "if", without it being a function parameter.

Yes.

$ echo "foo(  bar        baz" | sed -e 's/\t \{4\}/_tab_and_4_spaces_/' 
foo(  bar_tab_and_4_spaces_baz
$

You'll end up building lots of specific regexes to catch each of
these cases. Which is painful, and you'll still have to manually
clean stuff up afterwards.

> And the indentation of the parameters will change anyway, as we have
> parameters indented with tabs only, and with spaces only, and with
> some mix that makes no sense unless you configure your editor to show
> \t as an odd number of spaces except on the first Thursday of a month,
> but only on years that make a power of 2... Same as the rest of the
> code. :-) So I expect the resulting set to be roughly the same size as
> it is now. But I will break the patch by component, it should pass
> through then.

Yup, which is precisely why you should be looking at using a semantic
patching tool like coccinelle, not a literal one like sed that uses
regexes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
