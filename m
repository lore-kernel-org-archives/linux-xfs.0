Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CE36D29DF8
	for <xfs@oss.sgi.com>; Fri,  7 Feb 2014 10:39:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6218CAC00B
	for <xfs@oss.sgi.com>; Fri,  7 Feb 2014 08:39:28 -0800 (PST)
Received: from mail-ie0-f171.google.com (mail-ie0-f171.google.com
	[209.85.223.171]) by cuda.sgi.com with ESMTP id
	I3nbVBxNIIOZ9FSt (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 07 Feb 2014 08:39:26 -0800 (PST)
Received: by mail-ie0-f171.google.com with SMTP id as1so1786987iec.2
	for <xfs@oss.sgi.com>; Fri, 07 Feb 2014 08:39:26 -0800 (PST)
Received: from localhost (bas2-thornhill40-2925465484.dsl.bell.ca.
	[174.95.15.140])
	by mx.google.com with ESMTPSA id t4sm11163829igm.10.2014.02.07.08.39.23
	for <xfs@oss.sgi.com> (version=TLSv1 cipher=RC4-SHA bits=128/128);
	Fri, 07 Feb 2014 08:39:24 -0800 (PST)
Date: Fri, 7 Feb 2014 11:39:21 -0500
From: Mike Roth <mroth@gopivotal.com>
Subject: Troubleshooting log corruption
Message-ID: <20140207163921.GA43189@wintermute.home>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

I've recently had a few systems experience a hard failure (power
supply failure) and our XFS file system failed to recover.  The file
system fails to mount and I need to clear the logs before running
repair on them.  My understanding is that XFS should be more resilient
to this kind of issue.

I'm trying to dive a bit further into why this is happening (meta-data
corruption) and I'm wondering if anyone can provide some suggestions
as far as data to collect or tests to run to help understand why this
corruption is happening on system failures.

Thank you,
mike

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
