Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9D0SObC063586 for <xfs@oss.sgi.com>; Mon, 12 Oct 2009 19:28:25 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A7B4C18360
	for <xfs@oss.sgi.com>; Mon, 12 Oct 2009 17:29:53 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id c5v3ZcqIHpbe76Tn for
	<xfs@oss.sgi.com>; Mon, 12 Oct 2009 17:29:53 -0700 (PDT)
Message-ID: <4AD3C9FF.7010307@sandeen.net>
Date: Mon, 12 Oct 2009 19:29:51 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: simplify and unify source package generation
References: <1205635767.11581255391391231.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <1205635767.11581255391391231.JavaMail.root@mail-au.aconex.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Nathan Scott <nscott@aconex.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Nathan Scott wrote:
> ----- "Christoph Hellwig" <hch@infradead.org> wrote:
> 
>> Currently the build/ directory can create rpm, debian and source /
>> binary
>> tar packages.  The RPM generation is not used as all distributions
>> prefer,
>> their own spec files, and the binary tarball not used at all as it's
>> a not very useful format.  Reimplement the generation of the source
>> tarballs to use the source-link method used for the debian packages
>> and
>> get rid of the whole old package generation machinery.  Also fix a
>> small
>> bug in the link-based source directory creation which was not
>> including
>> the .pot file for gettext.
> 
> From looking through the patch it seems OK to me.  I haven't had a chance
> to test it out yet, though - but from just eyeballing it, and if noone
> pipes up complaining about the auto-rpm-build removal (I don't expect
> they will, at this stage of xfsprogs life) it all looks good and correct.
> 
> cheers.
> 

die rpmbuild die ;)

Long as building tarballs works I'm happy.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
