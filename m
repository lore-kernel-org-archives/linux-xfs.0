Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CEE1729DF8
	for <xfs@oss.sgi.com>; Thu,  2 Jan 2014 07:04:13 -0600 (CST)
Date: Thu, 2 Jan 2014 13:04:10 GMT
Message-Id: <201401021304.s02D4Agc028655@m2c-new.corp.sgi.com>
Subject: Re: XFS File System Monitor
From: support@sgi.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Rotem Ben Arye <rotem.benarye@gmail.com>
Cc: xfs@oss.sgi.com

Hello Rotem

We have received your email and wish to log your request. However we need to know the Serial Number (s/n) of your machine in order to do so.

The Serial Number is usually located on a white barcode label on the back of your machine.

Depending on your system type, you may also be able to determine the serial number by running one of the following commands:

1) "sysinfo -vv" (Irix)
2) "cat /proc/sgi_sn/system_serial_number" (Altix)
3) dmidecode |grep Serial |grep X  (Altix XE)
4) scash -p -c "dmidecode |grep Serial |grep X" (Altix XE Clusters with Scalimanage)
5) dmidecode  | grep "Serial Number" | grep Z (Altix ICE)
6) dmidecode -s system-serial-number (Altix UV 10)
7) From the OS, use the 'topology' command.  From the SMN, use the 'config' command.  (Altix UV 100 & UV 1000)
8) "wmic bios get serialnumber" from the command line (Windows 2003/2008)

Once we receive this information, we will be able to log a case.

Thank you in advance.

Regards,
SGI Global Customer Support Center

Corporate Office:
SGI, 46600 Landing Parkway, Fremont, CA 94538, USA

>
>
> To: support@sgi.com
> Date: 12:16 PM Thursday January 02nd, 2014(GMT)
> From: "Rotem Ben Arye" <rotem.benarye@gmail.com>
> CC: xfs@oss.sgi.com
> Subject: XFS File System Monitor
> 
> Hi, SGI Support Team.
>
> My Name is Rotem , I am a Linux/Unix System Administrator in web company
> at Israel. I have a question I want to appeal to you to get some advice.
> 
> In the last weekend we had crisis in one of the Production server in
> the comany ,the problem was defined by the Integrators as  "xfs file
> system corrupted"
>
> My question is , what are the open source tools , that we can use on
> runtime at production environment , to monitor and sample to get
> indication on mount XFS , That something is not living well, and can 
> lead to problem.
> 
> We are working in a Linux environment on CentOS distributions server.
> 
> Thank you,
> 
> Rotem Ben Arye
> 

-------------------------------------------------------------------------------
***** Have you tried Supportfolio? *****
Did you know that you can open cases via the SGI web portal Supportfolio?  Just click on the following link: https://support.sgi.com/login
-------------------------------------------------------------------------------

http://www.sgi.com/
Contact us: http://www.sgi.com/support/supportcenters.html

NB: Information in this message is SGI confidential. It is intended solely for the person(s) to whom it is addressed and may not be copied, used, disclosed or distributed to others without SGI consent. If you are not the intended recipient please will you notify me by email or telephone, delete the message from your system immediately and destroy any printed copies.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
