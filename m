Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2UG6YFL140251 for <xfs@oss.sgi.com>; Fri, 30 Mar 2012 11:06:34 -0500
Date: Fri, 30 Mar 2012 12:06:31 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: bug #917 - deadlock on log recovery
Message-ID: <20120330160631.GA19594@infradead.org>
References: <CALJQnoyM3V1Wntn5sHfxW2WwuCQuy6Qj9ukmb4WNLN5OV0ORqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CALJQnoyM3V1Wntn5sHfxW2WwuCQuy6Qj9ukmb4WNLN5OV0ORqQ@mail.gmail.com>
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
To: Kirill Malkin <kirill.malkin@starboardstorage.com>
Cc: xfs-masters@oss.sgi.com, xfs@oss.sgi.com

On Thu, Mar 22, 2012 at 01:34:00PM -0400, Kirill Malkin wrote:
> Hi,
> 
> I am wondering if someone had a chance to look at the bug #917. I
> filed it a couple of weeks ago, but haven?t seen any action. We are
> running into it quite a lot, and the only way out of it is to reboot
> the OS and drop the log. Below is another stack trace that is slightly
> different from the one I filed, but apparently it is the same bug.
> 
> Please let me know if you need any other input.

Can you reproduce this with a recent kernel?  2.6.32 is fairly old
and a lot of things have changed in this area.  I quickly looked
over the trace and nothing obvious springs to mind.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
