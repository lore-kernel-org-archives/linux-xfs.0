Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4L6f3of252400 for <xfs@oss.sgi.com>; Fri, 21 May 2010 01:41:04 -0500
Received: from mx01.bfk.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 70756A0378B
	for <xfs@oss.sgi.com>; Thu, 20 May 2010 23:44:39 -0700 (PDT)
Received: from mx01.bfk.de (mx01.bfk.de [193.227.124.2]) by cuda.sgi.com with
	ESMTP id WD4uvHmOAWFXXQI2 for <xfs@oss.sgi.com>;
	Thu, 20 May 2010 23:44:39 -0700 (PDT)
Subject: Re: XFS on 2.6.26: reading the first 4K of a large file takes ages
References: <8239xojfco.fsf@mid.bfk.de> <20100519114826.GA18224@infradead.org>
	<82sk5m7oyz.fsf@mid.bfk.de>
	<87zkztojwh.fsf@willster.local.flamingspork.com>
From: Florian Weimer <fweimer@bfk.de>
Date: Fri, 21 May 2010 06:43:15 +0000
In-Reply-To: <87zkztojwh.fsf@willster.local.flamingspork.com> (Stewart Smith's
	message of "Fri\, 21 May 2010 16\:20\:46 +1000")
Message-ID: <828w7d69h8.fsf@mid.bfk.de>
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
To: Stewart Smith <stewart@flamingspork.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

* Stewart Smith:

> On Thu, 20 May 2010 12:11:00 +0000, Florian Weimer <fweimer@bfk.de> wrote:
>> Thanks for confirming my hunch.  I don't think it's worth fixing this
>> in XFS.  The database should call posix_fallocate() before flushing
>> its internal cache to the file in essentially random order, but it's
>> difficult to get upstream to implement this (the source code is a bit
>> hard to follow, unfortunately).
>
> Which database?

Oracle Berkeley DB.

> You could always mount with allocsize

This happens with "allocsize=3D4194304".

> or use other tools to do the preallocation before things got too
> bad.

Is there a way to transparently preallocate a few GB after the current
end of the file?  That would be helpful because Berkeley DB wouldn't
have to know about it.

It's a legacy system, otherwise I would invest more effort into
putting some sort of preallocation somewhere deep into Berkeley DB.

-- =

Florian Weimer                <fweimer@bfk.de>
BFK edv-consulting GmbH       http://www.bfk.de/
Kriegsstra=DFe 100              tel: +49-721-96201-1
D-76133 Karlsruhe             fax: +49-721-96201-99

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
