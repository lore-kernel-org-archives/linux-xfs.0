Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0BA3229DF9
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 12:09:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id DD134304067
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 10:09:02 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id tMqMmnERTP1URFEa (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Dec 2013 10:08:58 -0800 (PST)
Date: Fri, 6 Dec 2013 10:08:58 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: nfs vs xfstests 193
Message-ID: <20131206180858.GA2803@infradead.org>
References: <20131106115648.GA24804@infradead.org>
 <52A1CF22.106@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52A1CF22.106@oracle.com>
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
To: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Vasily Isaenko <vasily.isaenko@oracle.com>, linux-nfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Dec 06, 2013 at 05:20:34PM +0400, Stanislav Kholmanskikh wrote:
> Just to make the behaviour more consistent between NFS and other
> "local" file systems as It was done by
> commit https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?id=0953e620de0538cbd081f1b45126f6098112a598

Seems like we got others in line with XFS behavior.  I'd prefer to
have NFS follow this as well.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
