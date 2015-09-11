Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 267877F37
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 03:20:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 17261304032
	for <xfs@oss.sgi.com>; Fri, 11 Sep 2015 01:20:26 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kT2i9zkjw5XAmXct (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Sep 2015 01:20:24 -0700 (PDT)
Date: Fri, 11 Sep 2015 10:20:20 +0200
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 0/13] xfs_repair: recombine cut&waste code in
	dir2.c/attr_repair.c
Message-ID: <20150911082020.GA2523@zion.usersys.redhat.com>
References: <1441827251-13128-1-git-send-email-sandeen@sandeen.net>
	<20150910092224.GB2613@zion.usersys.redhat.com>
	<55F1B4FC.5040207@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <55F1B4FC.5040207@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Thu, Sep 10, 2015 at 11:51:08AM -0500, Eric Sandeen wrote:
> On 9/10/15 4:22 AM, Carlos Maiolino wrote:
> > On Wed, Sep 09, 2015 at 02:33:58PM -0500, Eric Sandeen wrote:
> 
> ...
> 
> >> The last patch fixes up the dir vs. attr text in error messages
> >> and comments.  I do have a question about whether this is ok
> >> for i8n:
> >>
> >> 	printf(_("This string is %s"), _("awesome"));
> > 
> > This should be fine for i18n, I had used it a lot when I added i18n support in
> > gfs2-utils, and _() is the default macro that should embrace every string that
> > needs to be translated. It will be replaced by gettext("awesome"), and there is
> > no problem in using it as printf() argument for format specifiers.
> > 
> > What you should be careful though, is that how these strings will 'look' to the
> > person translating it, which, in most of cases, they are not going to look at
> > the code to get a better meaning of the string. So, the sentences to be
> > translated, should make sense by itself.
> > 
> > 
> > I particularly, don't like much the idea of split strings as you did in the
> > example, exactly because how it might look to the translators, both strings
> > makes the same sentence, but they will show to the translators as completely
> > different strings, and the translator might not be able to find the proper
> > grammatical construction. So, I'd do something like:
> > 
> > printf(funny ? _("This string is awesome") : _("This string is boring")) 
> > 
> > 
> > I know that I might sound picky here, but, this is the best way to avoid weird
> > and non-sense string translations.
> 
> No, that makes sense, but it kind of sucks, too - writing the same string

> twice everywhere, once for attr & once for dir, is a bit bleah.
> 
> Maybe I can restructure it such that it's more easily translatable,
> something like using a prefix, i.e.
> 
> %s: block %d is unreadable for inode %lld
> 
> -> turns into ->
> 
> dir: block %d is unreadable for inode %lld
>  - or -
> attr: block %d is unreadable for inode %lld
> 
> and then it's not cutting a sentence in half, to interfere with grammar
> from other languages ...
> 

Yep, that makes sense. Or, you can play with variables, but, that would make the
code only a huge spaghetti of strings and probably nobody would want to see
things like that.


> -Eric
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
