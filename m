Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Sep 2007 15:49:06 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l82Mn24p018419
	for <xfs@oss.sgi.com>; Sun, 2 Sep 2007 15:49:03 -0700
Message-ID: <46DB3E4B.3030106@sgi.com>
Date: Mon, 03 Sep 2007 08:50:51 +1000
From: Vlad Apostolov <vapo@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] log replay should not overwrite newer ondisk inodes
References: <46D6279F.40601@sgi.com> <46D6480F.4040307@sgi.com> <46D64CAD.6050705@sgi.com> <46D67FE6.20205@sgi.com> <46D68510.1020404@sgi.com> <46D77B79.3040104@sgi.com> <46D792A1.7030308@sgi.com> <20070831154822.GD734179@sgi.com>
In-Reply-To: <20070831154822.GD734179@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Mark Goodwin <markgw@sgi.com>, Lachlan McIlroy <lachlan@sgi.com>, Timothy Shimmin <tes@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

David Chinner wrote:
> An unlinked inode is only detectable by the mode parameter being zero.
> The rest of the inode will look valid.
What about the nlink count? Can't we detect unlinked inode by nlink == 0?

Regards,
Vlad
