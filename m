Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nB14bDW2095419
	for <linux-xfs@oss.sgi.com>; Mon, 30 Nov 2009 22:37:13 -0600
Received: from mail-pz0-f173.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5DA2BC1E3D
	for <linux-xfs@oss.sgi.com>; Mon, 30 Nov 2009 20:37:43 -0800 (PST)
Received: from mail-pz0-f173.google.com (mail-pz0-f173.google.com
	[209.85.222.173]) by cuda.sgi.com with ESMTP id
	IN5NoGTZCSAJaqbh for <linux-xfs@oss.sgi.com>;
	Mon, 30 Nov 2009 20:37:43 -0800 (PST)
Received: by pzk3 with SMTP id 3so3191249pzk.20
	for <linux-xfs@oss.sgi.com>; Mon, 30 Nov 2009 20:37:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B14936F.7040401@sandeen.net>
References: <389deec70911301805j37df7397l1c3ddbbad7e91768@mail.gmail.com>
	<4B14936F.7040401@sandeen.net>
Date: Tue, 1 Dec 2009 12:37:42 +0800
Message-ID: <389deec70911302037v19764c2cr7686b353c5e933fa@mail.gmail.com>
Subject: Re: can xfs_repair guarantee a complete clean filesystem?
From: hank peng <pengxihan@gmail.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@oss.sgi.com

2009/12/1 Eric Sandeen <sandeen@sandeen.net>:
> hank peng wrote:
>> When using xfs_repair, I want my XFS filesystem complete clean and
>> continue to work even if some files lost. Becase we use XFS in low-end
>> NAS box, customers want a tool to repair the filesystem when it has
>> problem and they allow some files be lost and don't want the whole
>> system to stop.
>> So, I wonder if xfs_repair or some other tools can satisfy this funciton?
>>
>
> Yes, that is exactly its purpose (any potential bugs notwithstanding...)
>
Thanks for your reply.
Is there some points I should notice about when using xfs_repair? I
used to encounter some cases in which xfs_repair complete successfully
but some errors like "Corrupt in memory detected" occured when the
filesytem is put into online for short time.
Should I reboot the machine and use xfs_repair before the damaged
filesystem is used, or some other options I should use?
In addition, I googled some information and found that some people say
xfs_check should be used before xfs_repair, is it right?

> -Eric
>



-- 
The simplest is not all best but the best is surely the simplest!

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
