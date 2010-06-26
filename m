Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5QBhMo3193785 for <xfs@oss.sgi.com>; Sat, 26 Jun 2010 06:43:22 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DA87A407138
	for <xfs@oss.sgi.com>; Sat, 26 Jun 2010 04:46:06 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 0KV2lPwFHQqmMQSl for
	<xfs@oss.sgi.com>; Sat, 26 Jun 2010 04:46:06 -0700 (PDT)
Date: Sat, 26 Jun 2010 07:46:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_quota report problem
Message-ID: <20100626114605.GC15157@infradead.org>
References: <Pine.LNX.4.58.1006241045580.12138@stud.pam.szczecin.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.1006241045580.12138@stud.pam.szczecin.pl>
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
To: Stanczak Slawomir <sws@stud.pam.szczecin.pl>
Cc: xfs@oss.sgi.com

On Thu, Jun 24, 2010 at 11:02:02AM +0200, Stanczak Slawomir wrote:
> Hi,
> 
> I use xfs on my Debian Linux system. I have one question.
> How can I display users with exceeded soft blocks limit only?
> 
> I can do:
> 
> xfs_quota -x -c report /home | grep day
> 
> xfs_quota -x -c report /home | grep day | awk '{print $1}'
> 
> but the solution isn't a good idea.
> 
> Have you any other idea?

I don't think it's implemented.  I can add it to xfs_quota for you.
Do you have an example of a quota tool that supports such functionality
so that we can have a similar interface?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
