Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E850B7F37
	for <linux-xfs@oss.sgi.com>; Tue, 16 Apr 2013 13:49:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C99908F8074
	for <linux-xfs@oss.sgi.com>; Tue, 16 Apr 2013 11:49:37 -0700 (PDT)
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id 7MOsYUJF1qxVmWPn (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Tue, 16 Apr 2013 11:49:33 -0700 (PDT)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1USAwd-0003Mk-TP
	for linux-xfs@oss.sgi.com; Tue, 16 Apr 2013 20:49:31 +0200
Received: from wombat.san-francisco.ca.us ([75.101.60.140])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 16 Apr 2013 20:49:31 +0200
Received: from kkeller by wombat.san-francisco.ca.us with local (Gmexim 0.1
	(Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 16 Apr 2013 20:49:31 +0200
From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: xfs_repair misses an fs error?
Date: Tue, 16 Apr 2013 11:44:54 -0700
Message-ID: <6qi04axkbr.ln2@goaway.wombat.san-francisco.ca.us>
References: <k5gu3axace.ln2@goaway.wombat.san-francisco.ca.us>
	<20130416162557.GD13938@destitution>
Mime-Version: 1.0
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
To: linux-xfs@oss.sgi.com

On 2013-04-16, Dave Chinner <david@fromorbit.com> wrote:
>
> Not recently. What version of xfs_repair are you using?

Hmm, perhaps this is a difference.  I believe (though, again I did very
poor logging, and I apologize) that the initial repair used 3.1.1.  The
recent successful repair definitely used 3.1.10.  Is it possible 3.1.1
is old enough that it might not have caught the issues I reported from
the 3.1.10 log?

--keith


-- 
kkeller@wombat.san-francisco.ca.us


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
