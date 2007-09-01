Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 01 Sep 2007 03:55:44 -0700 (PDT)
Received: from smtp2.poczta.onet.pl (smtp2.poczta.onet.pl [213.180.130.30])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l81Atc4p032162
	for <xfs@oss.sgi.com>; Sat, 1 Sep 2007 03:55:40 -0700
Received: from rudy.mif.pg.gda.pl ([153.19.42.16]:11329 "EHLO
	orion.wszechswiat.org" rhost-flags-OK-OK-OK-FAIL) by ps2.test.onet.pl
	with ESMTPA id S1610621023AbXIAKzhjqKuL (ORCPT
	<rfc822;xfs@oss.sgi.com>); Sat, 1 Sep 2007 09:55:37 -0100
Message-ID: <46D94507.8080006@op.pl>
Date: Sat, 01 Sep 2007 12:55:03 +0200
From: Bogdan <bogdandr@op.pl>
MIME-Version: 1.0
Subject: [PATCH] Re: About errors in XFS header  files and xfsprogs
References: <46D6F066.5000009@op.pl> <20070830165556.GA13308@infradead.org>
In-Reply-To: <20070830165556.GA13308@infradead.org>
Content-Type: multipart/mixed;
 boundary="------------050903060907000204070905"
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------050903060907000204070905
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: RIPEMD160

NOTE: a copy goes to the mailing list (because of the patch).

Christoph Hellwig pisze:
> On Thu, Aug 30, 2007 at 06:29:26PM +0200, Bogdan wrote:
>>                                The header files should not only be
>> ISO-C-compatible, but even ANSI-C-compatible. This will allow anyone
>> to use them.
> 
> Sais who?  The GNU C extensions are very useful for programming, and

 Sure, I like them too. But I also write programs and like them to be
available to as many, as possible.

> there is no reason to move to an inferior dialect.

 If you want xfsprogs compatible only with GCC, you're right. But GCC
is not the only compiler out there and some people using Linux/Unix
may use something else.
 So there is a reason - portability. Inserting

#ifdef __GNUC__
#endif

around GCC-specific statements isn't really that hard. I'm not asking
for compatibility with all architectures (which might require much
more work, especially with endianess, if needed). Maybe I'll do these
#defines myself in the future.
 I myself am using GCC, but others may not. How would you feel if you
had some great piece of software and had to change some 200 lines just
to compile it (because it was written, say, for MSVC or Borland with
compiler-specific stuff)?

>>  Please, make useful public functions available in header files.
>> Especially platform_check_ismounted() and platform_check_iswritable()
>> and other "platform" functions.
>>
>>  Also, anything that is a part of the public interface, should be in
>> the "xfs namespace", i.e. start with "xfs_". At least one issue of
>> this type is known: the list_head structure, declared in other files
>> from other libraries. Things like these are very important to fix,
>> because they are making other header files useless.
> 
> There is no such thing as a public inteface.

 Anything in header files that is usable for the program including
them, one might call a public interface. If libxfs.a had no public
interface, xfsprogs would not exist, because the library wouldn't have
any functions for them to call.
 If two headers define a function with the same name, we have a
conflict. Same goes for preprocessor macros. We have for example:

#define ACTIVE		1

in xfs_copy.c. If any other included header, say <pthread.h> or
<signal.h>, #defines the same name, xfs_copy.c will no longer compile.
Is this what everybody wants? Of course not. But this is exactly the
type of obstacle I've found when trying to use libxfs with libntfs
(will patch them too).

>  There's a good reason
> libxfs is not a shared libary - it's really nothing more but a collection
> of useful routines for the xfs utilities.

 Well, I'm writing a XFS utility, but its not only for XFS, hence the
conflicts. Libxfs is becoming a development library, not just a
private, internal-use bunch of routines. It is a part of a
'xfsprogs-devel' package, available probably not only for my system.
This should make you think that you aren't making the libxfs.a just
for yourselves, but also for everyone else. Thus, the library should
be designed with careful thinking, which produces less conflicts.
 Please, don't think "the user includes our file libxfs.h, so he/she
surely won't include xxx.h, yyy.h and zzz.h". Things just aren't like
this.
 You can't of course predict all header files the user will include,
and here's where inserting "xfs_" helps. You put everything in your
"namespace" using the prefix and assume no other library will use the
"xfs_" prefix. Here's where my hopes on libxfs (and partially on
libntfs, too) failed, but hopefully we will fix all the problems.

> If you think a proper shared library with a defined interface is a good
> thing you're probably right, and people would welcome you to work on one.

 Maybe one day. Now I can help at least a little. Start with applying
the attached patch to the xfsprogs development directory tree (in the
top dir, of course). This patch removes the conflicts between libxfs
and libntfs (at least those, which I've found). Any further patches
will be sent to the mailing list, unless required otherwise.

- --
Pozdrawiam/Regards - Bogdan                         (Linux & FreeDOS)
Kurs asemblera x86  (DOS & Linux):  http://rudy.mif.pg.gda.pl/~bogdro
Grupy dyskusyjne o asm:  pl.comp.lang.asm alt.pl.asm alt.pl.asm.win32
Rozmawiaj bezpiecznie: www.JabberPL.org Surfuj anonimowo: tor.eff.org

-----BEGIN PGP SIGNATURE-----

iD8DBQFG2UUANTrTaBxW2h4RA4/YAJ9xehmvenwZhLCUBybV/Qdlxj8faACgkyLG
u/VD0b2/xe8+LpopEGo2mgk=
=a7+K
-----END PGP SIGNATURE-----

--------------050903060907000204070905
Content-Type: application/x-gzip;
 name="xfs-portability-patch01.diff.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="xfs-portability-patch01.diff.gz"

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
ePX8tLPxP+SSgTiM0wAA

--------------050903060907000204070905
Content-Type: application/pgp-signature;
 name="xfs-portability-patch01.diff.gz.sig"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="xfs-portability-patch01.diff.gz.sig"

iD4DBQBG2UUHNTrTaBxW2h4RA7OuAJjlbt63fPxjdZbHQ7x911MCVJZ4AJ4h
QP5EkDCmT4wPK4hj2ZqjP5flbg==

--------------050903060907000204070905--
