Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 552348069
	for <xfs@oss.sgi.com>; Sat, 16 Mar 2013 07:14:12 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 378028F8033
	for <xfs@oss.sgi.com>; Sat, 16 Mar 2013 05:14:09 -0700 (PDT)
Received: from Ishtar.hc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id bxy1I1E7zKU6ohWU (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 16 Mar 2013 05:14:07 -0700 (PDT)
Message-ID: <5144620C.4040203@tlinx.org>
Date: Sat, 16 Mar 2013 05:14:04 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: enable test 032 (mkfs overwrite) for btrfs
References: <5140A2BC.7010800@redhat.com> <51435555.2020706@sgi.com>
	<5143568F.5060900@redhat.com>
In-Reply-To: <5143568F.5060900@redhat.com>
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
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>



Eric Sandeen wrote:

>>
>> It did not put mkfs.btrfs in /sbin.  This did however, validate all the error paths ;).
> Heh ;)
> Well, mixing & matching upstream installs from source w/ rpm-packaged binaries is usually asking for trouble. 
> I don't think it's a bug, just bad administrative practice ;)
----
	SuSE is moving most if not all of their boot-related binaries off of "/" and
putting
them in /usr, requiring that you either have 1 partition for / and /usr or you run
their initrd that will pre-mount /usr on "/".  Supposedly this is a requirement
of moving the the MS-compat boot architecture, "systemd" and is being done by all
the distros... (supposedly)...  At least RedHat and SuSE are going that way...

	It's great to boot up in single-user from your hard disk and be told mount
needs libs on a yet-to-be mounted partition...

;-/

	

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
