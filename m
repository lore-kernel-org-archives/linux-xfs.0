Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8DB617F63
	for <xfs@oss.sgi.com>; Fri, 31 Jul 2015 16:57:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E9235AC006
	for <xfs@oss.sgi.com>; Fri, 31 Jul 2015 14:57:43 -0700 (PDT)
Received: from e24smtp01.br.ibm.com (e24smtp01.br.ibm.com [32.104.18.85]) by
	cuda.sgi.com with ESMTP id KVguYMsXvOH8Uex2 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 31 Jul 2015 14:57:41 -0700 (PDT)
Received: from /spool/local
	by e24smtp01.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use
	Only! Violators will be prosecuted
	for <xfs@oss.sgi.com> from <ferseiti@linux.vnet.ibm.com>;
	Fri, 31 Jul 2015 18:57:40 -0300
Received: from d24relay02.br.ibm.com (d24relay02.br.ibm.com [9.13.184.26])
	by d24dlp02.br.ibm.com (Postfix) with ESMTP id 4287A1DC0071
	for <xfs@oss.sgi.com>; Fri, 31 Jul 2015 17:56:36 -0400 (EDT)
Received: from d24av03.br.ibm.com (d24av03.br.ibm.com [9.8.31.95])
	by d24relay02.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
	t6VLu1GW27918730
	for <xfs@oss.sgi.com>; Fri, 31 Jul 2015 18:56:02 -0300
Received: from d24av03.br.ibm.com (localhost [127.0.0.1])
	by d24av03.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
	t6VLvaI2003857 for <xfs@oss.sgi.com>; Fri, 31 Jul 2015 18:57:36 -0300
Message-ID: <55BBEF4F.6070809@linux.vnet.ibm.com>
Date: Fri, 31 Jul 2015 18:57:35 -0300
From: Fernando Seiti Furusato <ferseiti@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: xfsprogs fails to build on debian ppc64el
References: <55BB9271.6000300@gmx.net>
In-Reply-To: <55BB9271.6000300@gmx.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Daniel Bast <daniel.bast@gmx.net>, 793495@bugs.debian.org, xfs@oss.sgi.com
Cc: Breno Leitao <brenohl@br.ibm.com>

That error is common when configure is generated using out-of-date config.guess
and config.sub.
The ones that come with the package are, in fact, old.

This package used to run dh_autotools-dev_updateconfig and
dh_autotools-dev_restoreconfig, which worked because it only updates those
files.

They were replaced by dh_autoreconf and dh_autoreconf_clean, which should
update them, but does not run flawlessly.
I think something is wrong with the m4 macros but I am not sure what.
There are errors when running dh_autoreconf alone.

# dh_autoreconf
libtoolize: putting auxiliary files in AC_CONFIG_AUX_DIR, `.'.
libtoolize: copying file `./ltmain.sh'
libtoolize: putting macros in AC_CONFIG_MACRO_DIR, `m4'.
libtoolize: copying file `m4/libtool.m4'
libtoolize: copying file `m4/ltoptions.m4'
libtoolize: copying file `m4/ltsugar.m4'
libtoolize: copying file `m4/ltversion.m4'
libtoolize: copying file `m4/lt~obsolete.m4'
libtoolize: Consider adding `-I m4' to ACLOCAL_AMFLAGS in Makefile.am.
autoheader: warning: missing template: HAVE_UMODE_T
autoheader: Use AC_DEFINE([HAVE_UMODE_T], [], [Description])
autoheader: warning: missing template: HAVE___PSINT_T
autoheader: warning: missing template: HAVE___PSUNSIGNED_T
autoheader: warning: missing template: HAVE___U32
autoreconf: /usr/bin/autoheader failed with exit status: 1
dh_autoreconf: autoreconf -f -i returned exit code 1

I will keep working on it, but all I will be able to do if I get to a conclusion
is send a patch here.
Thus it will have to be dealt with by the maintainers anyway.

Regards.
-- 

Fernando Seiti Furusato
IBM Linux Technology Center

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
