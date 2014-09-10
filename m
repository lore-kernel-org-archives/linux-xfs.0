Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6F1A07F4E
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 20:10:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5D9DC8F804B
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 18:10:53 -0700 (PDT)
Received: from b.mx.filmlight.ltd.uk (b.mx.filmlight.ltd.uk [77.107.81.251])
	by cuda.sgi.com with SMTP id OCkD43DeugKAzfdg for
	<xfs@oss.sgi.com>; Tue, 09 Sep 2014 18:10:48 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Corrupted files
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <540F9FE9.7070500@mygrande.net>
Date: Wed, 10 Sep 2014 02:10:47 +0100
Message-Id: <3E40936B-A1F2-424D-B0B3-54B6C7B50B13@filmlight.ltd.uk>
References: <540F1B01.3020700@mygrande.net>	<CAA43vkXwHF9RHW-cbTZ91_vF6wiQ6o_+TQDL3=7kD9P4tErCNQ@mail.gmail.com>
	<CAA43vkWgh8-EjDXjkySUn+y18W1O+v_W5j+fQankRTgDCmc8tw@mail.gmail.com>
	<540F7E37.7020500@sandeen.net> <540F9FE9.7070500@mygrande.net>
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
To: Leslie Rhorer <lrhorer@mygrande.net>
Cc: Sean Caron <scaron@umich.edu>, Roger Willcocks <roger@filmlight.ltd.uk>, Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>


On 10 Sep 2014, at 01:48, Leslie Rhorer <lrhorer@mygrande.net> wrote:

>  The only ones remaining at issue are 3 files which cannot be read, written or deleted.

The most straightforward fix would be to note down the inode numbers of the three fies and then use xfs_db to clear the inodes; then run xfs_repair again.

See:

http://xfs.org/index.php/XFS_FAQ#Q:_How_to_get_around_a_bad_inode_repair_is_unable_to_clean_up

but before that try running the latest (3.2.1 I think) xfs_repair.

--
Roger

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
