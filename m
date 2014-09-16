Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 16AFA7F47
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 17:06:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 01C3C8F8039
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 15:06:18 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id QngQhAUHL2leqprA for <xfs@oss.sgi.com>;
	Tue, 16 Sep 2014 15:06:17 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 40D6560F9698
	for <xfs@oss.sgi.com>; Tue, 16 Sep 2014 17:06:17 -0500 (CDT)
Message-ID: <5418B459.1010204@sandeen.net>
Date: Tue, 16 Sep 2014 17:06:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2 V2] xfs_db: add crc manipulation commands
References: <540B4399.4020804@sandeen.net> <5418574A.8040102@sandeen.net>
In-Reply-To: <5418574A.8040102@sandeen.net>
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
To: xfs-oss <xfs@oss.sgi.com>

On 9/16/14 10:29 AM, Eric Sandeen wrote:
> This adds a new "crc" command to xfs_db for CRC-enabled filesystems.
> 
> If a structure has a CRC field, we can validate it, invalidate/corrupt
> it, or revalidate/rewrite it:
> 
> xfs_db> sb 0
> xfs_db> crc -v
> crc = 0x796c814f (correct)
> xfs_db> crc -i
> Metadata CRC error detected at block 0x0/0x200
> crc = 0x796c8150 (bad)
> xfs_db> crc -r
> crc = 0x796c814f (correct)

On reflection, do you think these should be more verbose, something like:

xfs_db> sb 0
xfs_db> crc -v
Validating crc:
crc = 0x796c814f (correct)
xfs_db> crc -i
Invalidating CRC:
Metadata CRC error detected at block 0x0/0x200
crc = 0x796c8150 (bad)
xfs_db> crc -r
Rewriting CRC:
crc = 0x796c814f (correct)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
