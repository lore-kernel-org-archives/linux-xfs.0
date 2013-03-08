Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A4F7D7FEC
	for <xfs@oss.sgi.com>; Fri,  8 Mar 2013 04:21:21 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 859888F8033
	for <xfs@oss.sgi.com>; Fri,  8 Mar 2013 02:21:21 -0800 (PST)
Received: from mail-pa0-f44.google.com (mail-pa0-f44.google.com
	[209.85.220.44]) by cuda.sgi.com with ESMTP id IeZ55i2wZQYVhTlU
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 08 Mar 2013 02:21:20 -0800 (PST)
Received: by mail-pa0-f44.google.com with SMTP id kp1so1218753pab.3
	for <xfs@oss.sgi.com>; Fri, 08 Mar 2013 02:21:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5134BBA4.3060305@sandeen.net>
References: <CANU9nTnvJS50vdQv2K0gKHZPvzzH5EY1qpizJNsqUobrr2juDA@mail.gmail.com>
	<512FA67D.2090708@sandeen.net>
	<CANU9nTm3vR3Z5JwRwou4vnNejstAkAsnBb2ivwx-KhnHHbWpoQ@mail.gmail.com>
	<5130DB54.9030503@sandeen.net>
	<CANU9nTkekrw2mdptFdK2RVUFXD=evt0sTZhB9VL+PKY8DTj11A@mail.gmail.com>
	<5134BBA4.3060305@sandeen.net>
From: Ole Tange <tange@binf.ku.dk>
Date: Fri, 8 Mar 2013 11:21:00 +0100
Message-ID: <CANU9nTntXh5spRYc80OhsBqgLnZcJGA2qBeVVQaywthD1RMu4w@mail.gmail.com>
Subject: Re: xfs_repair segfaults
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

On Mon, Mar 4, 2013 at 4:20 PM, Eric Sandeen <sandeen@sandeen.net> wrote:

> 2) so you could run a "real" non-"n" xfs_repair on a metadata image as a more realistic dry run

I have now done a 'xfs_repair' using the code in GIT. It failed, and I
then did 'xfs_repair -L' which succeeded.

Am I correct that I should now be able to mount the sparse disk-image
file and see all the filenames? In that case I am quite worried. I get
filenames like:

/mnt/disk/??5?z+hEOgl/?7?Psr1?aIH<?ip:??/>S??+??z=ozK/8_0/???d)
5JCG?eiBd?EVsNF'A?v?m?f;Fi6v)d>/?M%?A??J?)B<soGlc??QuY!e-<,6G?
X[Df?Wm^[?f 4|

My guess is some superblock is corrupt and that it should instead try
a backup superblock. It might be useful if xfs_repair could do this
automatically based on the rule of thumb that more than 90% of
filenames/dirnames match:

[- _.,=A-Za-z0-9':]* [([{]* [- _.,=A-Za-z0-9':]* []})]* [- _.,=A-Za-z0-9':]*

If it finds a superblock resulting in more then 10% not matching the
above it should probably ignore that superblock (unless the file names
are using non-latin characters - such as Japanese).


/Ole

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
