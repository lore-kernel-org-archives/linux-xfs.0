Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 808FF7F51
	for <xfs@oss.sgi.com>; Sun, 28 Jun 2015 17:12:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6D2B3304039
	for <xfs@oss.sgi.com>; Sun, 28 Jun 2015 15:12:33 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id UNDGO4ikZz9SLKTX for <xfs@oss.sgi.com>;
	Sun, 28 Jun 2015 15:12:27 -0700 (PDT)
Message-ID: <55907148.1050509@sandeen.net>
Date: Sun, 28 Jun 2015 17:12:24 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Q: xfs_db: invalid numrecs (*) in bmapbtd block
References: <CAGqmi75jFGjWvFFT5HTwyO1tv4-d4J=aVJ83L2zqNyWMDOz1RQ@mail.gmail.com>
In-Reply-To: <CAGqmi75jFGjWvFFT5HTwyO1tv4-d4J=aVJ83L2zqNyWMDOz1RQ@mail.gmail.com>
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
To: Timofey Titovets <nefelim4ag@gmail.com>, xfs@oss.sgi.com

On 6/28/15 1:44 PM, Timofey Titovets wrote:
> Good time of day list,
> i do regular check fragmentation on my servers and xfs_db show strange erros:

No need, really.

http://xfs.org/index.php/XFS_FAQ#Q:_The_xfs_db_.22frag.22_command_says_I.27m_over_50.25._Is_that_bad.3F

> # xfs_db -c frag -r /dev/sdc1
> invalid numrecs (51914) in bmapbtd block
> invalid numrecs (2827) in bmapbtd block

...

> actual 504454, ideal 126776, fragmentation factor 74.87%


 
> I already google error, and can't find any answer or explanation what
> is it, how danger it or something like.
> It's a production servers with several TB of data and this output make
> me unhappy. =.=

does xfs_repair find any errors?

> And i can't do fast stop it, unmount and check file system.
> (this is nfs server for virtual machines images)

Oh.  So you're doing it with an online/mounted filesystem?

The on-disk filesystem isn't necessarily consistent when mounted,
some of that consistency lives in the log.

You're likely just seeing that inconsitency because you're reading
it while it's mounted; possibly even while it's being modified.

-Eric

> Thanks for any help, anyway.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
