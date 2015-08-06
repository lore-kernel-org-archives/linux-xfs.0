Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2A7E77F76
	for <xfs@oss.sgi.com>; Thu,  6 Aug 2015 08:14:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 189B58F8035
	for <xfs@oss.sgi.com>; Thu,  6 Aug 2015 06:14:30 -0700 (PDT)
Received: from mx6-phx2.redhat.com (mx6-phx2.redhat.com [209.132.183.39]) by
	cuda.sgi.com with ESMTP id qmCAflT3h3cuojwC (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 06 Aug 2015 06:14:28 -0700 (PDT)
Date: Thu, 6 Aug 2015 09:13:15 -0400 (EDT)
From: Jan Tulak <jtulak@redhat.com>
Message-ID: <1490980415.3591793.1438866795648.JavaMail.zimbra@redhat.com>
In-Reply-To: <55C0E73B.1000904@sandeen.net>
References: <1156743222.24471614.1436281858017.JavaMail.zimbra@redhat.com>
	<1436346893-11831-1-git-send-email-jtulak@redhat.com>
	<1508777144.956841.1437482376774.JavaMail.zimbra@redhat.com>
	<20150726162530.GE29329@infradead.org>
	<1326157887.2004059.1438598404429.JavaMail.zimbra@redhat.com>
	<55BFA2C5.20408@redhat.com>
	<1050814645.2742881.1438702230663.JavaMail.zimbra@redhat.com>
	<55C0E73B.1000904@sandeen.net>
Subject: Re: [PATCH v3] xfsprogs: blkid is now mandatory
MIME-Version: 1.0
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
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com



----- Original Message -----
> From: "Eric Sandeen" <sandeen@sandeen.net>
> > Signature detection (if I understand you correctly 'signature of existing
> > FS') could be really disabled, I think. That would take care of
> > check_overwrite(). However, blkid is also used in get_topology. That one
> > calls blkid_get_topology, which uses blkid's functions for finding out
> > sector and io sizes.
> 
> Well, it would be sane to default to 512 sectors; if that fails it'll
> be obvious fairly quickly, and the user can always use the command line
> to specify 4k sectors (or stripe alignment, etc) manually.
> 
> > What I really can do is to say "on osx, you can mkfs only files," and cut
> 
> bleah!  ;)
> 
> > out the blkid parts. But it limits the usage on OS X even further.
> > Although, the removed code for non-blkid systems used platform_findsizes
> > as fallback. Are there some ugly, terrible monsters who would jump from
> > under the bed when doing that?
> 
> Well, the old findsizes was there for this reason, but now it's gone ;)

platform_findsizes is still there, in the "is file" branch. Small ifdef can
put it instead of blkid...

> 
> > However, this patch affects only mkfs. It still should be possible to use
> > xfs_db and xfs_repair even on block devices.
> 
> I don't know how invasive it'd be, but I think in the absence of blkid,
> we should still work, but lose signature detection, and fall back to geometry
> defaults.

It looks like it works. Though I need to do some testing before I send the patch.
Unfortunately, making FS tests without the ability to mount it on the machine 
requires USB drive shuffling and it is hard to automate it... :-)

What I think about is whether to write some warning in autoconf. Because it is
easy to forget to install libblkid-dev package on linux and with this patch,
it chancan change the behaviour unexpectedly when using autoconf for blkid 
detection.

Or maybe I could require blkid by default, and disable it with an argument
like LOCAL_CONFIGURE_OPTIONS="--enable-blkid=no". 

I think the config option is a better way - it can't happen you disable it just 
because you forget to install a package.

Cheers,
Jan


-- 
Jan Tulak
jtulak@redhat.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
