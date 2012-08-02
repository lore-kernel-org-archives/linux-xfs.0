Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q720O27F092950 for <xfs@oss.sgi.com>; Wed, 1 Aug 2012 19:24:02 -0500
Received: from pavilion.ashurst.eu.org (pavilion.ashurst.eu.org
	[85.119.82.45]) by cuda.sgi.com with ESMTP id o2EtOb8v0FIISzMx
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 01 Aug 2012 17:24:01 -0700 (PDT)
Received: from 79.70.112.87.dyn.plus.net ([87.112.70.79] helo=[192.168.1.155])
	by pavilion.ashurst.eu.org with esmtpsa
	(TLS1.0:RSA_AES_256_CBC_SHA1:32) (Exim 4.72)
	(envelope-from <andyjpb@ashurst.eu.org>) id 1SwjCo-0004s8-CJ
	for xfs@oss.sgi.com; Thu, 02 Aug 2012 01:23:59 +0100
Message-ID: <5019C89D.2020303@ashurst.eu.org>
Date: Thu, 02 Aug 2012 01:23:57 +0100
From: Andy Bennett <andyjpb@ashurst.eu.org>
MIME-Version: 1.0
References: <5019C5F9.1080302@ashurst.eu.org>
In-Reply-To: <5019C5F9.1080302@ashurst.eu.org>
Subject: Re: XFS Recovery Behaviour
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

> I didn't expect to see the import-2012-07-04/ directory again and I
> certainly didn't expect to see it populated with the card-2/ subdirectory.

I've been moving the files to my archive disk and now import-2012-07-28/
seems to be in a pickle:


-----
$ ls -la import-2012-07-28/
total 0

$ rmdir import-2012-07-28/
rmdir: failed to remove `import-2012-07-28/': Directory not empty

$ rm -fr import-2012-07-28/
rm: cannot remove `import-2012-07-28': Directory not empty

$ cd import-2012-07-28/

$ ls -la
total 0

$ touch hello
touch: cannot touch `hello': No such file or directory

$ cd .

$ cd ..

$
-----


I can't seem to remove it. It doesn't seem to contain '.' or '..'
entries but I do seem to be able to 'cd' in and out of it with bash
4.2.36(1). I also seem to be able to 'cd .' whilst I am in it.




... I tried 'umount'ing and 'mount'ing the filesystem.
Now it shows up thusly in 'ls -la':

-----
??????????  ? ?       ?             ?            ? import-2012-07-28
-----

'umount'ing and 'mount'ing again results in the same thing.


dmesg shows this for the two "re"mounts:

-----
[48160.832197] XFS (sda10): Mounting Filesystem
[48161.047407] XFS (sda10): Ending clean mount
[48247.692309] XFS (sda10): Mounting Filesystem
[48247.844421] XFS (sda10): Ending clean mount
-----




Does anyone have any idea how I can remove this entry?





Regards,
@ndy

-- 
andyjpb@ashurst.eu.org
http://www.ashurst.eu.org/
0x7EBA75FF

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
