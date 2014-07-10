Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id ADB237F3F
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2014 11:31:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A6825304032
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2014 09:31:24 -0700 (PDT)
Received: from mail-wg0-f42.google.com (mail-wg0-f42.google.com
	[74.125.82.42]) by cuda.sgi.com with ESMTP id v8hjpgPt4SgtflKG
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 10 Jul 2014 09:31:19 -0700 (PDT)
Received: by mail-wg0-f42.google.com with SMTP id l18so2348381wgh.1
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2014 09:31:16 -0700 (PDT)
Message-ID: <1405009872.31068.22.camel@jtulak>
Subject: Re: symlink loop for /lib64/libhandle.so
From: Jan =?UTF-8?Q?=C5=A4ul=C3=A1k?= <jan@tulak.me>
Date: Thu, 10 Jul 2014 18:31:12 +0200
References: <1404898212.7231.12.camel@jtulak>
	<20140709132836.GA65226@bfoster.bfoster>
	<20140710134851.GA26652@infradead.org>
In-Reply-To: <20140710134851.GA26652@infradead.org>
Mime-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Brian Foster <bfoster@redhat.com>, XFS mail list <xfs@oss.sgi.com>


> On 10 Jul 2014, at 15:48, Christoph Hellwig <hch@infradead.org> wrote:
> 
> On Wed, Jul 09, 2014 at 09:28:36AM -0400, Brian Foster wrote:
>>> If it not an intended behavior, I can try to find the source of the bug
>>> and make a patch (I'm new here :-).
>> 
>> I can reproduce this on fedora rawhide via 'make install-qa.' This is
>> not intended behavior. I couldn't tell you what the problem is, but
>> patches are certainly welcome. :)
> 
> This sounds like an fallout from the /lib -> /usr/lib symlink mess in
> Fedora.  Might be worth taking a look at the specfile how Eric worked
> around that for the RPM..

Yes. I'm trying to find out what exactly is causing the difference. I
have tried to use the same tarball which is used in Eric's RPM and it
did the same thing as the git version, so it is not something that
would change since his last build.

So far It seems that if I add DIST_ROOT, PKG_ROOT_SBIN_DIR and
PKG_ROOT_LIB_DIR arguments to the "make install-qa" commandm it works OK and
the libhandle.so placed in PKG_ROOT_LIB_DIR points correctly to
libandle.so.1.

Does this makes some sense to you?

Jan Tulak

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
