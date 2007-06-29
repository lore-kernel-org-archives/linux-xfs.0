Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 28 Jun 2007 23:39:31 -0700 (PDT)
Received: from zebday.corky.net (corky.net [212.150.53.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5T6dPtL030878
	for <xfs@oss.sgi.com>; Thu, 28 Jun 2007 23:39:26 -0700
Message-ID: <4684A728.1050405@corky.net>
Date: Fri, 29 Jun 2007 07:31:04 +0100
From: Just Marc <marc@corky.net>
MIME-Version: 1.0
Subject: Re: xfs_fsr, performance related tweaks
References: <4683ADF5.9050901@corky.net> <1183075929.15488.148.camel@edge.yarra.acx>
In-Reply-To: <1183075929.15488.148.camel@edge.yarra.acx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nscott@aconex.com
Cc: xfs@oss.sgi.com, andi@firstfloor.org

Hi Nathan, Andy,

I tried calling the ioctl of course, it does accept a path (also in the 
example in which it is used) but it returned EINVAL, I'll try again.

 > I guess one could define an additional dont-defrag (or perhaps
 > rather already-defrag) flag that is always
 > cleared when the file changes. That could be safely set here.

I had this in mind but thought not to bring it up as it's too low 
level.  Although I prefer this solution myself as it caters for all 
cases automatically.

 > But then I'm not sure it would be worth the effort. Why would you run 
fsr that often that it matters?

I run fsr all the time because in my case there is hundreds of gigs of 
new data added to each file system every day, some of it does badly need 
to be defragged as the files added are actively being served, not just 
stored.

 >Also I would expect that one can easily detect in many cases an 
defragmented file by looking at the number of extents in the inode only 
and that would
 > make it equivalent to the flag. The cases where this is not the case 
are probably rare too.

Well, this case would change from file to file (depending on its size) 
and a high number of extents may be acceptable for very large files so 
either come up with a formula that says "I can accept X extents per gig 
and not continue defragging" or do clear the no-defrag bit on file 
modification which is a cleaner solution.

Marc


Nathan Scott wrote:
> Just call the ioctl directly - fsr is already doing this in a bunch
> of places (even has a call to XFS_IOC_FSSETXATTR already, elsewhere).
> The xfsctl wrapper is just to give some tools platform independence -
> on IRIX (shares xfs_io code) some of the syscalls take paths, but on
> Linux only file descriptors are used.
>
> cheers.
>
> --
> Nathan
>
>
>   
