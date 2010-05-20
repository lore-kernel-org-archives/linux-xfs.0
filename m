Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4KC8n9B203322 for <xfs@oss.sgi.com>; Thu, 20 May 2010 07:08:50 -0500
Received: from mx01.bfk.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5BF991417AC1
	for <xfs@oss.sgi.com>; Thu, 20 May 2010 05:11:08 -0700 (PDT)
Received: from mx01.bfk.de (mx01.bfk.de [193.227.124.2]) by cuda.sgi.com with
	ESMTP id 4VW7CD1zvJmJCVE6 for <xfs@oss.sgi.com>;
	Thu, 20 May 2010 05:11:08 -0700 (PDT)
Subject: Re: XFS on 2.6.26: reading the first 4K of a large file takes ages
References: <8239xojfco.fsf@mid.bfk.de> <20100519114826.GA18224@infradead.org>
From: Florian Weimer <fweimer@bfk.de>
Date: Thu, 20 May 2010 12:11:00 +0000
In-Reply-To: <20100519114826.GA18224@infradead.org> (Christoph Hellwig's
	message of "Wed\, 19 May 2010 07\:48\:26 -0400")
Message-ID: <82sk5m7oyz.fsf@mid.bfk.de>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

* Christoph Hellwig:

> On Wed, May 19, 2010 at 11:33:27AM +0000, Florian Weimer wrote:
>> We've got a couple of rather large files, and with a cold cache,
>> reading the first 4K bytes of the file (e.g., just running
>> "head --bytes 4096" on it) takes ages, up to several minutes,
>> sometimes triggering the hang check timer.
>> =

>> I wonder if XFS reads the whole extent information into RAM when the
>> file is opened.  Is this the case, at least on 2.6.26?  Has this
>> changed in later versions, perhaps?
>
> Yes, XFS always reads in the extent map, and no this hasn't changed
> recently.

Okay, defragmenting seems to improve things considerably.  But it's
going to take a while: "extents before:5309152 after:13" *sigh*

Thanks for confirming my hunch.  I don't think it's worth fixing this
in XFS.  The database should call posix_fallocate() before flushing
its internal cache to the file in essentially random order, but it's
difficult to get upstream to implement this (the source code is a bit
hard to follow, unfortunately).

-- =

Florian Weimer                <fweimer@bfk.de>
BFK edv-consulting GmbH       http://www.bfk.de/
Kriegsstra=DFe 100              tel: +49-721-96201-1
D-76133 Karlsruhe             fax: +49-721-96201-99

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
