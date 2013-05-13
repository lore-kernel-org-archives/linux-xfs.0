Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A07B27CBF
	for <xfs@oss.sgi.com>; Mon, 13 May 2013 12:55:52 -0500 (CDT)
Message-ID: <51912928.3020300@sgi.com>
Date: Mon, 13 May 2013 12:55:52 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: Error during bulk removal of files
References: <CAEUQcejFPKDqqwbT_BNFJEVkUeAY=mgYGv-kUvLX6Ys7YQkqfg@mail.gmail.com>
	<518D22F0.8040405@sgi.com> <20130511011505.GB32675@dastard>
	<CAEUQceg6iy=TBrBkhan5bN5vO4y=JGcNy6LGhgfvO-7ereiB=Q@mail.gmail.com>
In-Reply-To: <CAEUQceg6iy=TBrBkhan5bN5vO4y=JGcNy6LGhgfvO-7ereiB=Q@mail.gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Subranshu Patel <spatel.ml@gmail.com>
Cc: xfs@oss.sgi.com

On 05/13/13 11:15, Subranshu Patel wrote:
>> What 2.6.32 kernel? Output of uname -a?
>
>   uname -a
> Linux machine1 2.6.32-279.el6.x86_64 #1 SMP Wed Jun 13 18:24:36 EDT
> 2012 x86_64 x86_64 x86_64 GNU/Linux
>
>   # cat /etc/issue
> Red Hat Enterprise Linux Server release 6.3 (Santiago)
>
> I am using mdtest program to delete 7 million files (of 1KB size).
> Total 128 concurrent mdtest process are there. Each process removes
> approx 54000 files ( 7 million / 128).
> mdtest runs for a while, after that, it gets blocked and does not do
> anything. However the machine is still responsive.
>

Is the delay log enabled? If so have you tried the command with it disabled?

Are you willing to take a crash of the hang? Or want to look at the 
entries on the AIL?

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
