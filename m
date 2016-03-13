Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0BE007CA1
	for <xfs@oss.sgi.com>; Sun, 13 Mar 2016 18:02:19 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D278B8F8035
	for <xfs@oss.sgi.com>; Sun, 13 Mar 2016 16:02:15 -0700 (PDT)
Received: from mail-vk0-f43.google.com (mail-vk0-f43.google.com
	[209.85.213.43]) by cuda.sgi.com with ESMTP id cv7nZFlkzGgKWTwd
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 13 Mar 2016 16:02:13 -0700 (PDT)
Received: by mail-vk0-f43.google.com with SMTP id k1so189707204vkb.0
	for <xfs@oss.sgi.com>; Sun, 13 Mar 2016 16:02:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160311230254.GG2792@jra3>
References: <1456733847-17982-1-git-send-email-agruenba@redhat.com>
	<20160311140134.GA14808@infradead.org>
	<CAHc6FU4t3yisCM=MXrHRmCja_A8eZOpVa1smJ0gUhv+vuUAuXA@mail.gmail.com>
	<CAH2r5mv3OTmPOQBV7xc-uZmB0gWxykXOCEVOcybx3tbHiViTZg@mail.gmail.com>
	<20160311230254.GG2792@jra3>
Date: Mon, 14 Mar 2016 00:02:13 +0100
Message-ID: <CAHc6FU5Bq9afVdNogc9DQYyyXwLfUopXW5ZnSuct3N+NvKW4Rg@mail.gmail.com>
Subject: Re: [PATCH v18 00/22] Richacls (Core and Ext4)
From: Andreas Gruenbacher <agruenba@redhat.com>
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
To: Jeremy Allison <jra@samba.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Trond Myklebust <trond.myklebust@primarydata.com>, LKML <linux-kernel@vger.kernel.org>, XFS Developers <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, Steve French <smfrench@gmail.com>, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>, linux-ext4 <linux-ext4@vger.kernel.org>, Anna Schumaker <anna.schumaker@netapp.com>

On Sat, Mar 12, 2016 at 12:02 AM, Jeremy Allison <jra@samba.org> wrote:
> On Fri, Mar 11, 2016 at 02:05:16PM -0600, Steve French wrote:
>> Sounds like I need to quickly rework the SMB3 ACL helper functions
>> for cifs.ko
>>
>> Also do you know where is the current version of the corresponding
>> vfs_richacl for
>> Samba which works with the current RichACL format?
>
> I have a patch for a new vfs_richacl somewhere. I remember
> sending it to Andreas for testing...

Ah, the patch was for testing, not resting ... how could I get that mixed up.

I've applied your patch to the latest master branch, made it compile
again, and fixed a few obvious problems. The results I get with
smbcacls look reasonable now.

The code is here:
  https://github.com/andreas-gruenbacher/samba richacl

I've used the following smb.conf:
  [richacl]
  comment = Richacl directory
  path = /mnt/ext4
  vfs objects = richacl
  writeable = yes
  browseable = yes

Is there a particular reason why you didn't make vfs_richacl a
dynamically loadable module?

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
