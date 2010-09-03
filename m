Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o83LJJTT007345 for <xfs@oss.sgi.com>; Fri, 3 Sep 2010 16:19:20 -0500
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3E6751E580BA
	for <xfs@oss.sgi.com>; Fri,  3 Sep 2010 14:19:59 -0700 (PDT)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id UlUSrvZK4pKySbuQ for
	<xfs@oss.sgi.com>; Fri, 03 Sep 2010 14:19:59 -0700 (PDT)
Date: Sat, 4 Sep 2010 07:19:51 +1000 (EST)
From: Nathan Scott <nathans@aconex.com>
Message-ID: <1211297770.647781283548791361.JavaMail.root@mail-au.aconex.com>
In-Reply-To: <AANLkTi=NhOdoX0VU7fyvYpgM+mbN8b3vC7QrkKrcnDk=@mail.gmail.com>
Subject: Re: Possible to preallocate files that always begin/end on stripe
	unit/width?
MIME-Version: 1.0
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
To: Green Guy <greentech3000@gmail.com>
Cc: xfs@oss.sgi.com


----- "Green Guy" <greentech3000@gmail.com> wrote:

> ... 
> I know that XFS metadata such as the log, AG info, etc also need to be
> accounted for, but I am not sure the best way to determine how much
> space they will take.
> 
> ...
> How can I determine the correct file size and preallocate them in a
> way where they always begin/end on stripe unit/width taking the
> filesystem overhead into account?
> Note: the log needs to stay on the same fs.
> 

There's no way to make a guaranteed aligned/sized allocation, but you
can ask for a "best effort" by using the sizing information returned
from the XFS_IOC_FSGEOMETRY syscall (via xfsctl).

cheers.

-- 
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
