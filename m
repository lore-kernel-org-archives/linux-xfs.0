Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4A6plnp252709 for <xfs@oss.sgi.com>; Mon, 10 May 2010 01:51:47 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 93ACE97E7CA
	for <xfs@oss.sgi.com>; Sun,  9 May 2010 23:54:16 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id heFQw9eDfrPRgMHg for
	<xfs@oss.sgi.com>; Sun, 09 May 2010 23:54:16 -0700 (PDT)
Received: from int-mx04.intmail.prod.int.phx2.redhat.com
	(int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o4A6rvCr026731
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 10 May 2010 02:53:58 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o4A6rvK9019897
	for <xfs@oss.sgi.com>; Mon, 10 May 2010 02:53:57 -0400
Received: from [10.64.48.185] (vpn1-48-185.bne.redhat.com [10.64.48.185])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id o4A6rtBq010916
	for <xfs@oss.sgi.com>; Mon, 10 May 2010 02:53:56 -0400
Message-ID: <4BE7AD82.90300@gmail.com>
Date: Mon, 10 May 2010 16:53:54 +1000
From: Mark Goodwin <goodwinos@gmail.com>
MIME-Version: 1.0
Subject: Re: xfs and raid5 - "Structure needs cleaning for directory open"
References: <20100510022033.GB7165@dastard>
In-Reply-To: <20100510022033.GB7165@dastard>
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
To: xfs@oss.sgi.com

On 05/10/2010 12:20 PM, Dave Chinner wrote:
> On Sun, May 09, 2010 at 08:48:00PM +0200, Rainer Fuegenstein wrote:
>>
>> today in the morning some daemon processes terminated because of
>> errors in the xfs file system on top of a software raid5, consisting
>> of 4*1.5TB WD caviar green SATA disks.
>
> Reminds me of a recent(-ish) md/dm readahead cancellation fix - that
> would fit the symptoms of (btree corruption showing up under heavy IO
> load but no corruption on disk. However, I can't seem to find any
> references to it at the moment (can't remember the bug title), but
> perhaps your distro doesn't have the fix in it?

If it's the bug that Dave's thinking of, it's an issue with md
error handling and the BIO_UPTODATE flag, see :
http://www.mail-archive.com/linux-raid@vger.kernel.org/msg06628.html

For RHEL, this is addressed in Red Hat BZ 512552
https://bugzilla.redhat.com/show_bug.cgi?id=512552

upstream commit c2b00852fbae4f8c45c2651530ded3bd01bde814

Cheers
-- Mark

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
