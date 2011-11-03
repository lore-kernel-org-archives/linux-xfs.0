Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA3AsNZp262072 for <xfs@oss.sgi.com>; Thu, 3 Nov 2011 05:54:23 -0500
Received: from dmz-mailsec-scanner-6.mit.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7675721C21B
	for <xfs@oss.sgi.com>; Thu,  3 Nov 2011 03:54:22 -0700 (PDT)
Received: from dmz-mailsec-scanner-6.mit.edu (DMZ-MAILSEC-SCANNER-6.MIT.EDU
	[18.7.68.35]) by cuda.sgi.com with ESMTP id BE8CFXxk6zrnAw2D
	for <xfs@oss.sgi.com>; Thu, 03 Nov 2011 03:54:22 -0700 (PDT)
Subject: Re: [PATCH 6/8] xfstests: add fiemap operation to fsstress
Mime-Version: 1.0 (Apple Message framework v1251.1)
From: Theodore Tso <tytso@mit.edu>
In-Reply-To: <20111102195534.GB22500@infradead.org>
Date: Thu, 3 Nov 2011 06:54:16 -0400
Message-Id: <FA2EDC7F-92EC-449E-9FBC-B7955283DFAC@mit.edu>
References: <1319849297-3506-1-git-send-email-dmonakhov@openvz.org>
	<1319849297-3506-7-git-send-email-dmonakhov@openvz.org>
	<20111102195534.GB22500@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Theodore Tso <tytso@mit.edu>, xfs@oss.sgi.com, Dmitry Monakhov <dmonakhov@openvz.org>, aelder@sgi.com, linux-fsdevel@vger.kernel.org, hch@lst.de


On Nov 2, 2011, at 3:55 PM, Christoph Hellwig wrote:

> Alex, Eric, Dave - should we add new tests with the new operations
> Dmitry added, or is adding new ops to the existing tests fine?

One argument for adding new ops to existing tests is that it makes the run =
time of the entire test suite take longer.   A QA pass is already taking qu=
ite a while, and it would be nice if we could keep xfstests as efficient as=
 possible in terms of the maximum testing coverage per time spent running t=
he test suite=85.

-- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
