Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9QMQYPI004610 for <xfs@oss.sgi.com>; Fri, 26 Oct 2012 17:26:34 -0500
Message-Id: <20121026222514.883460703@sgi.com>
Date: Fri, 26 Oct 2012 17:25:14 -0500
From: bpm@sgi.com
Subject: [patch 0/1] xfsdump: Polish translation
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7607189999752396397=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Jakub Bogusz <qboosh@pld-linux.org>
Cc: xfs@oss.sgi.com

--===============7607189999752396397==
Content-Type: text/plain

Hi Jakub,

   I'm reposting your Polish translation in patch form because I'm having
   trouble getting it to work.  We're working toward a userspace release and I
   wanted to make sure to pull this in.  Could you take a look and see if I've
   done something wrong?  I am able to get xfs_fsr to work in multiple
   languages:


~/xfsdump # export LANG=de_DE
~/xfsdump # xfs_fsr -h
xfs_fsr: Ung�ltige Option -- h
Aufruf: xfs_fsr [-d] [-v] [-n] [-s] [-g] [-t Zeit] [-p Durchl�ufe] [-f leftf] 
        [-m mtab] xfs_fsr [-d] [-v] [-n] [-s] [-g] xfsdev | Verz. | Datei ...

Optionen:
       -n              Nichts tun, nur interessant mit -v. Im mtab-Modus
                       nicht effektiv.
       -s               Nur Statistiken ausgeben.
       -g              Ausgabe in's Syslog (Vorgabe, wenn stdout kein tty).
       -t Zeit         Ausf�hrdauer in Sekunden.
       -p Durchl�ufe   Anzahl der Durchl�ufe vor Beenden der globalen
                       Reorganisation.
       -f leftoff      Benutzen Sie dies anstelle von /var/tmp/.fsrlast_xfs.
       -m mtab         Etwas anderes als /etc/mtab benutzen.
       -d              Fehlersuche, noch mehr ausgeben.
       -v               Detailliert, mehr vs - mehr Details.

~/xfsdump # export LANG=pl_PL
~/xfsdump # xfs_fsr -h
xfs_fsr: b��dna opcja -- 'h'
Sk�adnia: xfs_fsr [-d] [-v] [-n] [-s] [-g] [-t czas] [-p przebiegi] [-f leftf] [-m mtab]
          xfs_fsr [-d] [-v] [-n] [-s] [-g] xfsdev | katalog | plik ...

Opcje:
       -n              Nie robienie niczego, przydatne tylko z -v.
                       Nieprzydatne w trybie mtab.
       -s              Tylko wypisanie statystyk.
       -g              Pisanie do sysloga (domy�lne je�li stdout to nie tty).
       -t czas         Czas dzia�ania w sekundach.
       -p przebiegi    Liczba przebieg�w przed zako�czeniem reorganizacji.
       -f leftoff      U�ycie tego pliku zamiast /var/tmp/.fsrlast_xfs.
       -m mtab         U�ycie pliku innego ni� /etc/mtab.
       -d              Diagnostyka, du�o wi�cej informacji.
       -v              Tym wi�cej szczeg��w, im wi�cej opcji -v.

However, with xfsdump I always get English, even when using the existing German
translation:

nfs6:~/xfsdump # export LANG=de_DE
nfs6:~/xfsdump # xfsdump -h
xfsdump: version 3.1.0 (dump format 3.0)
xfsdump: usage: xfsdump [ -a (dump DMF dualstate files as offline) ]
                        [ -b <blocksize> ]
                        [ -c <media change alert program>  ]
                        [ -d <dump media file size>  ]
                        [ -e (allow files to be excluded) ]
                        [ -f <destination> ... ]
                        [ -h (help) ]
                        [ -l <level> ]
                        [ -m (force usage of minimal rmt) ]
                        [ -o (overwrite tape) ]
                        [ -p <seconds between progress reports> ]
                        [ -q <use QIC tape settings> ]
                        [ -s <subtree> ... ]
                        [ -t <file> (use file mtime for dump time ]

I suspect that the problem is xfsdump specific, and since the German
translation isn't working either, your Polish translation is seems not likely
to be the problem.  Do you have any suggestions?

Also, could you extend your Signed-off-by: ?

Thanks much,
Ben


--===============7607189999752396397==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7607189999752396397==--
